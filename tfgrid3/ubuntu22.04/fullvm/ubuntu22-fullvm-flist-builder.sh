#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
	    echo "This script must be run as root" >&2
	        exit 1
fi

# Check if API_KEY provided or not
if [ -z "$1" ]; then
    echo "Usage: $0 <API_KEY>"
    exit 2
fi

API_KEY=$1

# Install arch-install-scripts package to use arch-chroot
apt-get update
apt-get install arch-install-scripts -y

# Setup and Bootstrap
mkdir ubuntu-jammy
debootstrap jammy ubuntu-jammy http://archive.ubuntu.com/ubuntu

# Prepare the chroot environment script
cat <<EOF > ubuntu-jammy/root/setup_inside_chroot.sh
#!/bin/bash
export PATH=/usr/local/sbin/:/usr/local/bin/:/usr/sbin/:/usr/bin/:/sbin:/bin
rm /etc/resolv.conf
echo 'nameserver 1.1.1.1' > /etc/resolv.conf
apt-get update
apt-get install cloud-init openssh-server curl initramfs-tools -y
cloud-init clean
apt-get install linux-modules-extra-5.15.0-25-generic -y
echo 'fs-virtiofs' >> /etc/initramfs-tools/modules
update-initramfs -c -k all
apt-get clean
EOF

chmod +x ubuntu-jammy/root/setup_inside_chroot.sh

# Enter the new environment using arch-chroot and execute the setup script
arch-chroot ubuntu-jammy /root/setup_inside_chroot.sh

# Clean up
rm ubuntu-jammy/root/setup_inside_chroot.sh
rm -rf ubuntu-jammy/dev/*

# Check if extract-vmlinux is available and install if it's not
if ! command -v extract-vmlinux &>/dev/null; then
	    echo "extract-vmlinux not found, installing..."
	    curl -O https://raw.githubusercontent.com/torvalds/linux/master/scripts/extract-vmlinux
	    chmod +x extract-vmlinux
            mv extract-vmlinux /usr/local/bin
fi

# Kernel Extraction
extract-vmlinux ubuntu-jammy/boot/vmlinuz | tee ubuntu-jammy/boot/vmlinuz-5.15.0-25-generic.elf > /dev/null
mv ubuntu-jammy/boot/vmlinuz-5.15.0-25-generic.elf ubuntu-jammy/boot/vmlinuz-5.15.0-25-generic

# Create a compressed archive of the configured system for uploading to hub.
tar -czf ubuntu-jammy.tar.gz -C ubuntu-jammy .

# Upload flist
# Ensure API_KEY is set
if [ -z "$API_KEY" ]; then
	    echo "API_KEY is not set. Please set your API_KEY environment variable." >&2
	        exit 2
fi

curl -X POST -H "Authorization: Bearer $API_KEY" -F "file=@ubuntu-jammy.tar.gz" https://hub.grid.tf/api/flist/me/upload