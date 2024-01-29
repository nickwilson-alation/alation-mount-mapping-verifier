#!/bin/bash

# Configuration file
CONFIG_FILE="volume_config.conf"

# Function to check mount
check_mount() {
    local volume="$1"
    local desired_mount="$2"

    local current_mounts=$(grep "/dev/$volume" /proc/mounts | awk '{print $2}')

    if [ -z "$current_mounts" ]; then
        echo "❌ $volume is not mounted"
        return 1
    fi

    if echo "$current_mounts" | grep -qx "$desired_mount"; then
        echo "✅ $volume mounted to correct directory ($desired_mount)"
    else
        echo "❌ $volume not mounted to correct directory (should be $desired_mount)"
        return 1
    fi
}

# Function to check fstab entry
check_fstab() {
    local volume="$1"
    local desired_mount="$2"

    local uuid=$(lsblk -no UUID "/dev/$volume")

    if [ -z "$uuid" ]; then
        echo "⚠️  $volume does not have a UUID, cannot check fstab"
        return 1
    fi

    # Check fstab for the UUID with and without quotes
    if grep -q -e "UUID=\"$uuid\"" -e "UUID=$uuid" /etc/fstab; then
        local fstab_mount=$(grep -e "UUID=\"$uuid\"" -e "UUID=$uuid" /etc/fstab | awk '{print $2}' | tr -d '"')

        if [ "$fstab_mount" == "$desired_mount" ]; then
            echo "✅ $volume properly set up to re-mount on restart (UUID: $uuid Mount point: $fstab_mount)"
        else
            echo "❌ $volume not properly set up to re-mount on restart (UUID: $uuid Mount point: $fstab_mount Should be mounted at: $desired_mount)"
        fi
    else
        echo "❌ $volume not properly set up to re-mount on restart (UUID: $uuid has no entry in fstab)"
    fi
}

# New Function to check bind mounts
check_bind_mounts() {
    local volume="$1"

    local mounts_info=$(grep "/dev/$volume" /proc/mounts)

    if [ -z "$mounts_info" ]; then
        echo "ℹ️   $volume has no bind mounts"
        return 0
    fi

    local count=$(echo "$mounts_info" | wc -l)
    echo "ℹ️ $volume has $count bind mount(s):"
    local i=1
    echo "$mounts_info" | while read -r line; do
        echo "$i. $line"
        ((i++))
    done
}

# Main logic to iterate over configurations
while IFS=: read -r volume mount_point; do
    if [ ! -z "$volume" ] && [ ! -z "$mount_point" ]; then
	echo "---------------------------------------------"
        echo "Checking $volume..."
        check_mount "$volume" "$mount_point"
        check_fstab "$volume" "$mount_point"
        check_bind_mounts "$volume"
        echo ""
    fi
done < "$CONFIG_FILE"

# End of script