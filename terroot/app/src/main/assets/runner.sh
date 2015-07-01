#!/system/bin/sh
exec 2>&1

echo "temporary root start"
chmod 777 /data/data/com.terrain.terroot/files/run_root_shell /data/data/com.terrain.terroot/files/deploy.sh /data/data/com.terrain.terroot/files/setup_busybox.sh
/data/data/com.terrain.terroot/files/run_root_shell -c "/data/data/com.terrain.terroot/files/deploy.sh"
/data/data/com.terrain.terroot/files/run_root_shell -c "/data/data/com.terrain.terroot/files/setup_busybox.sh"
echo "temporary root finish"