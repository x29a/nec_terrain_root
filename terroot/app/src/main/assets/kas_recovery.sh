#!/system/bin/sh
exec 2>&1

echo "kas.recovery script start"

if [[ -x /data/local/tmp/root/run_root_shell && -x /data/local/tmp/root/sgdisk && -f /data/data/com.terrain.terroot/files/kas.recovery.bin ]]
then
    TIMESTAMP="$(date +"%Y%m%d%H%M%S")"
    SCRIPT="/data/local/tmp/root/kas_recovery_script.sh"

    # build script
    echo "#!/system/bin/sh" > ${SCRIPT}
    echo "/data/local/tmp/root/sgdisk -d 11 /dev/block/mmcblk0" >> ${SCRIPT}
    echo "/data/local/tmp/root/sgdisk -n 11:557056:589823 /dev/block/mmcblk0" >> ${SCRIPT}
    echo "/data/local/tmp/root/sgdisk -c 11:recovery /dev/block/mmcblk0" >> ${SCRIPT}
    echo "/data/local/tmp/root/sgdisk -t 11:FFFF /dev/block/mmcblk0" >> ${SCRIPT}
    echo "/system/bin/dd if=/data/data/com.terrain.terroot/files/kas.recovery.bin of=/dev/block/mmcblk0 bs=512 seek=557056" >> ${SCRIPT}
    echo "/system/bin/sync" >> ${SCRIPT}

    # execute as root
    /data/local/tmp/root/run_root_shell -c "(chmod 777 ${SCRIPT}) && ${SCRIPT}"

else
    echo "assets needed"
fi

echo "kas.recovery script finished"