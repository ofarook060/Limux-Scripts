#!/system/bin/sh
export CHROOT=/data/local/debian

# 1. MOUNT SYSTEM AND STORAGE
echo "[*] Mounting filesystems..."
mkdir -p $CHROOT/mnt/sdcard

mount -o bind /dev $CHROOT/dev
mount -t proc proc $CHROOT/proc
mount -t sysfs sysfs $CHROOT/sys
mount -o bind /dev/pts $CHROOT/dev/pts
mount -o bind /sdcard $CHROOT/mnt/sdcard

# Fix Android DNS
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > $CHROOT/etc/resolv.conf

# 2. ENTER CHROOT (Using your working command)
echo "[*] Entering Debian Chroot..."
chroot $CHROOT /bin/su - root

# 3. AUTOMATIC CLEANUP ON EXIT
echo "[*] Exited Debian. Cleaning up mounts..."
umount -f $CHROOT/mnt/sdcard
umount -f $CHROOT/dev/pts
umount -f $CHROOT/sys
umount -f $CHROOT/proc
umount -f $CHROOT/dev
echo "[+] Done!"

