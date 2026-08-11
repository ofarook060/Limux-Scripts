#!/system/bin/sh
export CHROOT=/data/local/debian

# Create mount points inside Debian if they do not exist
mkdir -p $CHROOT/mnt/sdcard

# Mount essential system paths
mount -o bind /dev $CHROOT/dev
mount -t proc proc $CHROOT/proc
mount -t sysfs sysfs $CHROOT/sys
mount -o bind /dev/pts $CHROOT/dev/pts

# Mount Android Phone Storage
mount -o bind /sdcard $CHROOT/mnt/sdcard

# Fix Android DNS (Static injection)
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > $CHROOT/etc/resolv.conf

# Enter chroot with corrected Home, Path, and Environment variables
# chroot $CHROOT /usr/bin/env -i HOME=/root TERM=$TERM PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /bin/bash --login
# chroot $CHROOT /bin/bash --login
chroot $CHROOT /bin/su - root
