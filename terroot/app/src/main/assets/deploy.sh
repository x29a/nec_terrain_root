#!/system/bin/sh
cat /data/data/com.terrain.terroot/files/busybox > /data/local/tmp/busybox
cat /data/data/com.terrain.terroot/files/run_root_shell > /data/local/tmp/run_root_shell
cat /data/data/com.terrain.terroot/files/setup_busybox.sh > /data/local/tmp/setup_busybox.sh
cat /data/data/com.terrain.terroot/files/su > /data/local/tmp/su
cat /data/data/com.terrain.terroot/files/superuser.apk > /data/local/tmp/superuser.apk
chmod 777 /data/local/tmp/busybox /data/local/tmp/run_root_shell /data/local/tmp/setup_busybox.sh /data/local/tmp/su

# partition tools
mkdir -p /data/local/tmp/.system/xbin/
cat /data/data/com.terrain.terroot/files/parted > /data/local/tmp/.system/xbin/parted
cat /data/data/com.terrain.terroot/files/sgdisk > /data/local/tmp/.system/xbin/sgdisk
chmod 777 /data/local/tmp/.system/xbin/sgdisk /data/local/tmp/.system/xbin/parted