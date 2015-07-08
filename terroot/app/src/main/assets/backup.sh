#!/system/bin/sh
exec 2>&1

echo "backup script start"
/system/xbin/su -c "/system/xbin/parted /dev/block/mmcblk0 unit B print > /data/local/tmp/partition_layout.txt"
/system/xbin/su -c "/system/xbin/sgdisk -p /dev/block/mmcblk0 > /data/local/tmp/partition_sectors.txt"
/system/xbin/su -c "/system/xbin/sgdisk --backup=/data/local/tmp/mmcblk0.gpt /dev/block/mmcblk0"
/system/xbin/su -c "/system/bin/dd if=/dev/block/mmcblk0 of=/data/local/tmp/boot.img bs=1 skip=305659904 count=10485760"
/system/xbin/su -c "/system/bin/dd if=/dev/block/mmcblk0 of=/data/local/tmp/recovery.img bs=1 skip=316669952 count=10485760"
echo "backup script finished"