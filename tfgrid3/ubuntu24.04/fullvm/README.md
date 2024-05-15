# Creating Minimal Ubuntu Noble 24.04 FullVM FLIST : A Step-by-Step Guide

## Automated Process

**Script Name**: `ubuntu24-fullvm-flist-builder.sh`

This script automates the setup, configuration, archiving, and uploading of an Ubuntu system ready for use as an FLIST.

```bash
chmod +x ubuntu24-fullvm-flist-builder.sh
./ubuntu24-fullvm-flist-builder.sh ${your_api_key_here}
```
---
## Manual Process

### Install arch-install-scripts package to use arch-chroot
```
sudo apt install arch-install-scripts -y
```

### Setup and Bootstrap
```
mkdir ubuntu-noble
sudo debootstrap noble ubuntu-noble http://archive.ubuntu.com/ubuntu
```
#### Enter the new environment using arch-chroot.
```
arch-chroot ubuntu-noble/
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
apt-get install linux-modules-extra-6.8.0-31-generic -y
echo 'fs-virtiofs' >> /etc/initramfs-tools/modules
update-initramfs -c -k all
apt-get clean
```

### Clean up
```
rm -rf ubuntu-noble/dev/*
```

### Kernel Extraction
```
sudo ./extract-vmlinux ubuntu-noble/boot/vmlinuz | sudo tee ubuntu-noble/boot/vmlinuz-6.8.0-31-generic.elf > /dev/null
sudo mv ubuntu-noble/boot/vmlinuz-6.8.0-31-generic.elf ubuntu-noble/boot/vmlinuz-6.8.0-31-generic
```

### Create a compressed archive of the configured system for uploading to hub.
```
tar -czf ubuntu-noble.tar.gz -C ubuntu-noble .
```

### Uploading flist
#### From the hub you can generate api key to use
```
clsecret="$API_KEY"
curl -X Post -H "Authorization: Bearer ${clsecret}" -F "file=@ubuntu-noble.tar.gz"  https://hub.grid.tf/api/flist/me/upload
```
---

## Testing 
 - For now test it through terraform 