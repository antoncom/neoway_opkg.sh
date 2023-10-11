#!/bin/sh

# As Neoway N725 frimware provide Read-Only file structure
# for many target location, like /usr/lib, /usr/bin, etc.,
# then we need to use OverlayFS to make the location writable.

# How to use #
##############
# 1. Put the script to the device, to some writable part of file system, for example to /data/script
# 2. Edit /etc/init.d/boot file to add the mounting process on boot, e.g. just
#    place the following string at the end of /etc/init.d/boot:
#    /data/script/mount.sh
# 3. Reboot the device
# 4. Check the result by "mount" command in shell
##############

# /usr Read-Write
mkdir -p /data/overlay/usr
grep -q ubi0:usr /proc/mounts || /bin/mount -o noatime -t tmpfs ubi0:usr /data/overlay/usr

mkdir -p /data/overlay/usr/root
mkdir -p /data/overlay/usr/work
grep -q "ubi0:usr /usr overlay" /proc/mounts || /bin/mount -o noatime,lowerdir=/usr,upperdir=/data/overlay/usr/root,workdir=/data/overlay/usr/work -t overlay ubi0:usr /usr


# /lib Read-Write
mkdir -p /data/overlay/lib
grep -q "ubi0:lib" /proc/mounts || /bin/mount -o noatime -t tmpfs ubi0:lib /data/overlay/lib

mkdir -p /data/overlay/lib/root
mkdir -p /data/overlay/lib/work
grep -q "ubi0:lib /lib overlay" /proc/mounts || /bin/mount -o noatime,lowerdir=/lib,upperdir=/data/overlay/lib/root,workdir=/data/overlay/lib/work -t overlay ubi0:lib /lib

# /sbin Read-Write
mkdir -p /data/overlay/sbin
grep -q ubi0:sbin /proc/mounts || /bin/mount -o noatime -t tmpfs ubi0:sbin /data/overlay/sbin

mkdir -p /data/overlay/sbin/root
mkdir -p /data/overlay/sbin/work
grep -q "ubi0:sbin /sbin overlay" /proc/mounts || /bin/mount -o noatime,lowerdir=/sbin,upperdir=/data/overlay/sbin/root,workdir=/data/overlay/sbin/work -t overlay ubi0:sbin /sbin


# /bin Read-Write
mkdir -p /data/overlay/bin
grep -q ubi0:bin /proc/mounts || /bin/mount -o noatime -t tmpfs ubi0:bin /data/overlay/bin

mkdir -p /data/overlay/bin/root
mkdir -p /data/overlay/bin/work
grep -q "ubi0:bin /bin overlay" /proc/mounts || /bin/mount -o noatime,lowerdir=/bin,upperdir=/data/overlay/bin/root,workdir=/data/overlay/bin/work -t overlay ubi0:bin /bin
