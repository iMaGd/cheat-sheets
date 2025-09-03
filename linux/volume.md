
## Adding a volume

#### Format volume:
```bash
mkfs.ext4 -F  /dev/disk/by-id/scsi-0HC_Volume_20481010
```

#### Create directory
```bash
mkdir /mnt/vol1
```

#### Mount volume
```bash
mount -o discard,defaults /dev/disk/by-id/scsi-0HC_Volume_20481010 /mnt/vol1
```

#### Add volume to fstab

Ensure that the volume will be mounted again after server is rebooted.

```bash
echo "/dev/disk/by-id/scsi-0HC_Volume_20481010 /mnt/vol1 ext4 discard,nofail,defaults 0 0" >> /etc/fstab
```

The volume is now accessible at /mnt/vol1 for data storage.


## After resizing a volume

1. Verify the disk size (for ext4 File System)

```bash
lsblk
```

2. Resize the partition (if necessary):
```bash
sudo fdisk /dev/sdX
```

3. Resize the file system:
```bash
sudo resize2fs /dev/sdX
```

4. Verify the file system size:
```bash
df -h
```