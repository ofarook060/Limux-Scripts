#!/bin/sh

# Provide full paths for Magisk environment
PATH=/sbin:/system/bin:/system/xbin:/data/adb/apks/bin:$PATH

# Path of DEBIAN rootfs
DEBIANPATH="/data/local/tmp/chrootDebian"

# CRITICAL: Wait 20 seconds for Android to finish booting its own dev tree
sleep 20

# Fix setuid issue
busybox mount -o remount,dev,suid /data

# Function to safely mount filesystems without duplicates
safe_mount() {
    if ! busybox mount | grep -q "$2"; then
        busybox mount "$1" "$2" "$3" "$4"
    fi
}

# Bind essential system filesystems
safe_mount "--bind /dev" "$DEBIANPATH/dev"
safe_mount "--bind /sys" "$DEBIANPATH/sys"
safe_mount "--bind /proc" "$DEBIANPATH/proc"

# FORCE re-mounting of devpts to fix the PTY allocation issue
busybox umount -l "$DEBIANPATH/dev/pts" 2>/dev/null
busybox mount -t devpts -o gid=5,mode=620 devpts "$DEBIANPATH/dev/pts"

# /dev/shm for Electron apps
mkdir -p $DEBIANPATH/dev/shm
safe_mount "-t tmpfs -o size=256M tmpfs" "$DEBIANPATH/dev/shm"

# Mount sdcard
mkdir -p $DEBIANPATH/sdcard
safe_mount "--bind /sdcard" "$DEBIANPATH/sdcard"

# Fix required SSH directories inside chroot
mkdir -p $DEBIANPATH/run/sshd
chmod 0755 $DEBIANPATH/run/sshd

# Start SSH server inside chroot in the background
if ! pgrep -f "$DEBIANPATH/usr/sbin/sshd" > /dev/null; then
    busybox chroot $DEBIANPATH /usr/sbin/sshd
fi
