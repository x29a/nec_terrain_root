#!/system/bin/sh

cd /data/local/tmp

mkdir .system
mkdir .system/xbin

mv busybox .system/xbin
chown 0.0 .system/xbin/busybox
chmod 755 .system/xbin/busybox

mv su .system/xbin
chown 0.0 .system/xbin/su
chmod 6755 .system/xbin/su

cd .system/xbin
ln -s busybox cp
ln -s busybox test
ln -s busybox free
ln -s busybox find
ln -s busybox more
ln -s busybox which
ln -s busybox grep
ln -s busybox pstree
ln -s busybox wget
ln -s busybox seq
ln -s busybox sed
ln -s busybox clear
./busybox cp -p /system/xbin/* .
cd -

mount -o bind /data/local/tmp/.system/xbin /system/xbin
mount -o suid -o remount /system/xbin
