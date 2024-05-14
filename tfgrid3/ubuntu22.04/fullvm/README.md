# Creating Minimal Ubuntu Jammy FullVM FLIST : A Step-by-Step Guide

## Automated Process

**Script Name**: `ubuntu22-flist-builder.sh`

This script automates the setup, configuration, archiving, and uploading of an Ubuntu system ready for use as an FLIST.

```bash
chmod +x ubuntu22-flist-builder.sh
./ubuntu22-flist-builder.sh ${your_api_key_here}
```
---
## Manual Process

### Install arch-install-scripts package to use arch-chroot
```
sudo apt install arch-install-scripts -y
```

### Setup and Bootstrap
```
mkdir ubuntu-jammy
sudo debootstrap jammy ubuntu-jammy http://archive.ubuntu.com/ubuntu
```
#### Enter the new environment using arch-chroot.
```
arch-chroot ubuntu-jammy/
```

### Configure the system PATH and networking settings, then update the package repository and install necessary packages.
```
export PATH=/usr/local/sbin/:/usr/local/bin/:/usr/sbin/:/usr/bin/:/sbin:/bin
rm /etc/resolv.conf
echo 'nameserver 1.1.1.1' > /etc/resolv.conf
apt-get update
apt-get install cloud-init openssh-server curl initramfs-tools -y
```

### Cloud-init and Kernel Modules
#### Prepare the system for cloud environments using cloud-init and install additional kernel modules.
```
cloud-init clean
apt-get install linux-modules-extra-5.15.0-25-generic -y
echo 'fs-virtiofs' >> /etc/initramfs-tools/modules
update-initramfs -c -k all
apt-get clean
```

### Clean up
```
rm -rf ubuntu-jammy/dev/*
```

### Kernel Extraction
```
sudo ./extract-vmlinux ubuntu-jammy/boot/vmlinuz | sudo tee ubuntu-jammy/boot/vmlinuz-5.15.0-25-generic.elf > /dev/null
sudo mv ubuntu-jammy/boot/vmlinuz-5.15.0-25-generic.elf ubuntu-jammy/boot/vmlinuz-5.15.0-25-generic
```

### Create a compressed archive of the configured system for uploading to hub.
```
tar -czf ubuntu-jammy.tar.gz -C ubuntu-jammy .
```

### Uploading flist
#### From the hub you can generate api key to use
```
clsecret="$API_KEY"
curl -X Post -H "Authorization: Bearer ${clsecret}" -F "file=@ubuntu-jammy.tar.gz"  https://hub.grid.tf/api/flist/me/upload
```
---
## Testing 
 - For now test it through terraform  