#!/system/bin/sh
exec 2>&1

echo "modGPT script start"

if [[ -x /data/local/tmp/root/run_root_shell && -x /data/local/tmp/root/parted && -x /data/local/tmp/root/sgdisk ]]
then
    TIMESTAMP="$(date +"%Y%m%d%H%M%S")"
    SCRIPT="/data/local/tmp/root/modgpt_script.sh"

    # build script
    echo "#!/system/bin/sh" > ${SCRIPT}
    echo "/system/bin/mkdir -p /data/local/tmp/backup/ && chmod 777 /data/local/tmp/backup/" >> ${SCRIPT}
    echo "/data/local/tmp/root/sgdisk -d 11 /dev/block/mmcblk0" >> ${SCRIPT}
    echo "/data/local/tmp/root/sgdisk -n 11:557056:589823 /dev/block/mmcblk0 -v" >> ${SCRIPT}
    echo "/data/local/tmp/root/sgdisk -c 11:recovery /dev/block/mmcblk0 -v" >> ${SCRIPT}
    echo "/data/local/tmp/root/sgdisk -t 11:FFFF /dev/block/mmcblk0 -v" >> ${SCRIPT}
    echo "/data/local/tmp/root/parted /dev/block/mmcblk0 unit B print > /data/local/tmp/backup/${TIMESTAMP}_new_partition_layout.txt" >> ${SCRIPT}
    echo "/data/local/tmp/root/sgdisk -p /dev/block/mmcblk0 > /data/local/tmp/backup/${TIMESTAMP}_new_partition_sectors.txt" >> ${SCRIPT}
    echo "/system/bin/sync" >> ${SCRIPT}

    # execute as root
    /data/local/tmp/root/run_root_shell -c "(chmod 777 ${SCRIPT}) && ${SCRIPT}"

else
    echo "assets needed"
fi

echo "modGPT script finished"