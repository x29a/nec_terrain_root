#!/system/bin/sh
exec 2>&1

echo "backup script start"

if [[ -x /data/local/tmp/root/run_root_shell && -x /data/local/tmp/root/parted && -x /data/local/tmp/root/sgdisk ]]
then
    TIMESTAMP="$(date +"%Y%m%d%H%M%S")"
    SCRIPT="/data/local/tmp/root/backup_script.sh"

    # build script
    echo "#!/system/bin/sh" > ${SCRIPT}
    echo "/system/bin/mkdir -p /data/local/tmp/backup/ && chmod 777 /data/local/tmp/backup/" >> ${SCRIPT}
    echo "/data/local/tmp/root/parted /dev/block/mmcblk0 unit B print > /data/local/tmp/backup/${TIMESTAMP}_partition_layout.txt" >> ${SCRIPT}
    echo "/data/local/tmp/root/sgdisk -p /dev/block/mmcblk0 > /data/local/tmp/backup/${TIMESTAMP}_partition_sectors.txt" >> ${SCRIPT}
    echo "/data/local/tmp/root/sgdisk --backup=/data/local/tmp/backup/${TIMESTAMP}_mmcblk0.gpt /dev/block/mmcblk0" >> ${SCRIPT}
    echo "/system/bin/dd if=/dev/block/mmcblk0 of=/data/local/tmp/backup/${TIMESTAMP}_boot.img bs=512 skip=596992 count=20480" >> ${SCRIPT}
    echo "/system/bin/dd if=/dev/block/mmcblk0 of=/data/local/tmp/backup/${TIMESTAMP}_recovery.img bs=512 skip=618496 count=20480" >> ${SCRIPT}
    echo "chmod 777 /data/local/tmp/backup/*" >> ${SCRIPT}
    echo "/system/bin/sync" >> ${SCRIPT}

    # execute as root
    /data/local/tmp/root/run_root_shell -c "(chmod 777 ${SCRIPT}) && ${SCRIPT}"
else
    echo "assets needed"
fi

echo "backup script finished"