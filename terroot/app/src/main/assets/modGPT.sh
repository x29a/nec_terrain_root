#!/system/bin/sh
exec 2>&1

echo "modGPT script start"
/system/xbin/su -c "/system/xbin/sgdisk -d 11 /dev/block/mmcblk0"
/system/xbin/su -c "/system/xbin/sgdisk -n 11:558000:578479 /dev/block/mmcblk0 -v"
/system/xbin/su -c "/system/xbin/sgdisk -c 11:recovery /dev/block/mmcblk0 -v"
/system/xbin/su -c "/system/xbin/sgdisk -t 11:FFFF /dev/block/mmcblk0 -v"
/system/xbin/su -c "/system/xbin/parted /dev/block/mmcblk0 unit B print > /data/local/tmp/new_partition_layout.txt"
/system/xbin/su -c "/system/xbin/sgdisk -p /dev/block/mmcblk0 > /data/local/tmp/new_partition_sectors.txt"
/system/xbin/su -c "/system/bin/sync"
echo "modGPT script finished"