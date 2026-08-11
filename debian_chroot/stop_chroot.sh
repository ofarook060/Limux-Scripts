#!/system/bin/sh
export CHROOT=/data/local/debian

# Unmount paths in reverse order
umount -f $CHROOT/mnt/sdcard
umount -f $CHROOT/dev/pts
umount -f $CHROOT/sys
umount -f $CHROOT/proc
umount -f $CHROOT/dev

