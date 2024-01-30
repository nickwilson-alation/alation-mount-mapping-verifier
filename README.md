# Alation Volume Mount Mapping Verifier

# Overview
This script is designed to verify if specific volumes in a Linux system (specifically tested on Amazon Linux) are mounted to their correct directories. Additionally, it checks if these volumes are properly configured in the `/etc/fstab` file for remounting on restart. It also lists any bind mounts associated with each volume.

# Features
* Verifies if volumes are mounted to specified directories.
* Checks `/etc/fstab` entries for proper setup.
* Lists all bind mounts for each volume.

# Requirements
* Bash shell
* Access to `/etc/fstab` and mount information
* Sudo privileges (if required to access certain volume or system information)

# Configuration
* Config File: `volume_config.conf`
   * Format: `volume_name:desired_mount_point`
   * Example: `nvme1n1:/backup`

# Usage
1. Set up configuration: Edit `volume_config.conf` to include the volumes and their desired mount points. Use the format `volume_name:mount_point` (one per line).
2. Run the script:

   ```
   ./verify_mount.sh
   ```

# Output
* The script will output whether each volume is mounted to its correct directory.
* It will indicate if the volume is properly set up in fstab for remount on restart.
* It will list all bind mounts associated with each volume.

## Example Output:

```
---------------------------------------------
Checking nvme1n1...
✅ nvme1n1 mounted to correct directory (/backup)
✅ nvme1n1 properly set up to re-mount on restart (UUID: e4cf66c1-5284-4492-abf6-f60dde4e1b96 Mount point: /backup)
ℹ️ nvme1n1 has 2 bind mount(s):
1. /dev/nvme1n1 /backup ext4 rw,nosuid,nodev,noexec,relatime 0 0
2. /dev/nvme1n1 /opt/alation/alation-17.0.0.49181/data2 ext4 rw,nosuid,nodev,noexec,relatime 0 0

---------------------------------------------
Checking nvme2n1...
✅ nvme2n1 mounted to correct directory (/data)
✅ nvme2n1 properly set up to re-mount on restart (UUID: f284c550-bee6-4642-8829-fdda28e733a8 Mount point: /data)
ℹ️ nvme2n1 has 2 bind mount(s):
1. /dev/nvme2n1 /data ext4 rw,nosuid,nodev,noexec,relatime 0 0
2. /dev/nvme2n1 /opt/alation/alation-17.0.0.49181/data1 ext4 rw,nosuid,nodev,noexec,relatime 0 0

---------------------------------------------
Checking nvme0n1p1...
✅ nvme0n1p1 mounted to correct directory (/)
✅ nvme0n1p1 properly set up to re-mount on restart (UUID: 2a7884f1-a23b-49a0-8693-ae82c155e5af Mount point: /)
ℹ️ nvme0n1p1 has 1 bind mount(s):
1. /dev/nvme0n1p1 / xfs rw,noatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
```

# Notes
* Ensure the configuration file is correctly formatted.
* The script must be run with appropriate permissions to access volume and mount information.

# Disclaimer

This project and all the code contained within this repository is provided "as is" without warranty of any kind, either expressed or implied, including, but not limited to, the implied warranties of merchantability and fitness for a particular purpose. The entire risk as to the quality and performance of the project is with you.

The author, including Alation, shall not be responsible for any damages whatsoever, including direct, indirect, special, incidental, or consequential damages, arising out of or in connection with the use or performance of this project, even if advised of the possibility of such damages.

Please understand that this project is provided for educational and informational purposes only. Always ensure proper testing, validation and backup before implementing any code or program in a production environment.

By using this project, you accept full responsibility for any and all risks associated with its usage.