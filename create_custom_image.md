# Prerequisites

```
apt-get install \
   debootstrap \
   qemu-utils \
   qemu-system \
   genisoimage
```

# Create a workspace directory

```
mkdir $HOME/cloud-image
```

# create a 30G virtual hard disk

```
cd $HOME/cloud-image
dd if=/dev/zero of=ubuntu-cloud.raw bs=1 count=0 seek=32212254720 status=progress

```

# create patitions

#### replace this with gparted and create gbt partition table

```
DISK=ubuntu-cloud.raw

# First, create a gpt partition table /boot/efi

parted $DISK mklabel gpt

# Secondly, create the esp partition of 100M

parted $DISK mkpart primary 1 100M

# Mark first part as esp

parted $DISK set 1 esp on

# create second partion /boot
parted $DISK mkpart primary 100M 600M

# Use the remaining part as root that takes the remaining
# space on disk
parted $DISK mkpart primary 600M 100%

# To verify everything is correct do

parted $DISK print
```

the above script simply creates two partitions and make the first one bootable

# starting the loop device

```
losetup -fP ubuntu-cloud.raw
```

make sure it exists

```
losetup -a
```

you should see an entry like this

```
/dev/loop0: [65025]:258090 (/root/cloud-image/ubuntu-cloud.raw)
```

also to make sure it has two partitions execute

```
# lsblk
NAME      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0       7:0    0    30G  0 loop
├─loop0p1 259:0    0    94M  0 part
├─loop0p2 259:1    0   477M  0 part
└─loop0p3 259:2    0  29.4G  0 part
loop1       7:1    0  49.6M  1 loop /snap/snapd/17883
loop2       7:2    0  61.9M  1 loop /snap/core20/1405
loop0       7:3    0 136.6M  1 loop /snap/lxd/23983
loop4       7:4    0  49.6M  1 loop
loop5       7:5    0  63.2M  1 loop /snap/core20/1695
loop6       7:6    0 136.4M  1 loop /snap/lxd/23972
vda       254:0    0   100G  0 disk
├─vda1    254:1    0  99.9G  0 part /
├─vda14   254:14   0     4M  0 part
└─vda15   254:15   0   106M  0 part /boot/efi
vdb       254:16   0     2M  1 disk

```

# format the two partition on loop0 (which is our image in this case)

```

mkfs.vfat -F 32  /dev/loop0p1
mkfs.ext4 -L boot /dev/loop0p2
mkfs.ext4 -L cloud-root /dev/loop0p3

```

# create chroot dir and mount root (loop0p3 in our case, the ~29G partition)

```
mkdir chroot
mount /dev/loop0p3 chroot/
```

# mount boot partition (loop0p2) to chroot/boot

```
mkdir  chroot/boot
mount /dev/loop0p2 chroot/boot
```

# mount boot partition (loop0p1) to chroot/boot/efi

```
mkdir  chroot/boot/efi
mount /dev/loop0p1 chroot/boot/efi
```

# get ubuntu from bootstrap

```

 debootstrap \
   --arch=amd64 \
   --variant=minbase \
   --components "main,universe" \
   --include "ca-certificates,cron,iptables,isc-dhcp-client,libnss-myhostname,ntp,ntpdate,rsyslog,ssh,sudo,dialog,whiptail,man-db,curl,dosfstools,e2fsck-static" \
   jammy \
   ./chroot \
   http://us.archive.ubuntu.com/ubuntu/

```

# configure external mount points

```
mount --bind /dev chroot/dev
mount --bind /run chroot/run
```

# chroot environment

```
chroot ./chroot
```

now our root file system became the chroot dir

# configure system the following config are necessary to be able to finish installtions without errors

```
mount none -t proc /proc

mount none -t sysfs /sys

mount none -t devpts /dev/pts

export HOME=/root

export LC_ALL=C
echo "threefold" > /etc/hostname
```

# configure apt sources

```
cat <<EOF > /etc/apt/sources.list
deb http://us.archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse
deb http://us.archive.ubuntu.com/ubuntu/ jammy-updates main restricted universe multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ jammy-updates main restricted universe multiverse
deb http://us.archive.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
EOF
```

# configure fstab

```
cat <<EOF > /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system>         <mount point>       <type>  <options>                       <dump>  <pass>
/dev/vda3               /                    ext4    errors=remount-ro               0       1
/dev/vda2               /boot/               ext4    defaults                        0       2
/dev/vda1               /boot/efi            vfat    umask=0077                      0       1
EOF
```

# Install systemd

```
apt-get update
apt-get install -y systemd-sysv

```

# configure machine-id and divert

```
dbus-uuidgen > /etc/machine-id
ln -fs /etc/machine-id /var/lib/dbus/machine-id

dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl

```

# install grub, cloud-init and some utils

```
apt-get install -y \
    vim \
    os-prober \
    ifupdown \
    network-manager \
    resolvconf \
    locales \
    build-essential \
    module-assistant \
    cloud-init \
    grub-pc \
    grub2 \
    grub-efi-amd64-bin \
    linux-generic

```

# configure interfaces

```

cat <<EOF > /etc/network/interfaces

# This file describes the network interfaces available on your system

# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/\*

# The loopback network interface

auto lo
iface lo inet loopback
EOF

```

# Reconfigure packages

```

dpkg-reconfigure locales
dpkg-reconfigure resolvconf

```

## configure network manager

```

cat <<EOF > /etc/NetworkManager/NetworkManager.conf
[main]
rc-manager=resolvconf
plugins=ifupdown,keyfile
dns=default

[ifupdown]
managed=false
EOF

dpkg-reconfigure network-manager

```

# install grub

```

grub-install --target=x86_64-efi --efi-directory=/boot/efi --removable /dev/loop0

```

note were not installing grub on any partition but were are passing the whole dist

# Change default values as follows

```

vim /etc/default/grub

```

And make sure to change GRUB_CMDLINE_LINUX_DEFAULT as follows

```

GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 console=tty console=ttyS0"

```

Note: we removed the quiet and add the console flags.

Also set the GRUB_TIMEOUT to 0 for a faster boot

```
GRUB_TIMEOUT=1

```

this should be 0 but for some reason on ubuntu if it is 0 it defaults to 10 !

then run

```

update-grub2

```

run blkid to get the root partition UUID to set in /boot/grub/grub

```

# blkid

.
.
/dev/loop0p3: LABEL="cloud-root" UUID="3db56ba9-c113-4346-811e-55ad2be7fddb" BLOCK_SIZE="4096" TYPE="ext4" PARTLABEL="primary" PARTUUID="9a6d2bd7-b7d6-418c-bda9-c86ff14c0a19"
.
.

```

in /boot/grub/grub replace `root=/dev/loop0p3` with `root=UUID=3db56ba9-c113-4346-811e-55ad2be7fddb`

```

linux /vmlinuz-5.15.0-56-generic root=UUID=3db56ba9-c113-4346-811e-55ad2be7fddb ro single nomodeset dis_ucode_ldr

```

# cleaning up

```

# If you installed software, be sure to run

cloud-init clean
truncate -s 0 /etc/machine-id
rm /sbin/initctl

# remove the divert

dpkg-divert --rename --remove /sbin/initctl
apt-get clean

rm -rf /tmp/\* ~/.bash_history

umount /proc

umount /sys

umount /dev/pts

export HISTSIZE=0

exit

```

## unbind mount points

```

umount chroot/dev
umount chroot/run

```

## umount loop partitions

```

umount /dev/loop0p1
umount /dev/loop0p2
umount /dev/loop0p3

```

## detach loop device

```

losetup -D

```
