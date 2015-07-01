#!/system/bin/sh
cat /data/data/com.terrain.terroot/files/busybox > /data/local/tmp/busybox
cat /data/data/com.terrain.terroot/files/run_root_shell > /data/local/tmp/run_root_shell
cat /data/data/com.terrain.terroot/files/setup_busybox.sh > /data/local/tmp/setup_busybox.sh
cat /data/data/com.terrain.terroot/files/su > /data/local/tmp/su
cat /data/data/com.terrain.terroot/files/superuser.apk > /data/local/tmp/superuser.apk
chmod 777 /data/local/tmp/busybox /data/local/tmp/run_root_shell /data/local/tmp/setup_busybox.sh /data/local/tmp/su