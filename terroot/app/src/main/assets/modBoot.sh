#!/system/bin/sh
exec 2>&1

echo "modBoot script start"
chmod 777 /data/data/com.terrain.terroot/files/modboot.img 
/system/xbin/su -c "/system/bin/dd if=/data/data/com.terrain.terroot/files/modboot.img of=/dev/block/mmcblk0p11 bs=1024"
echo "modBoot script finished"