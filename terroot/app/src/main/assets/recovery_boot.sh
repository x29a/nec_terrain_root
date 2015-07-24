#!/system/bin/sh
exec 2>&1

echo "recboot script start"

if [[ -x /data/local/tmp/root/run_root_shell && -f /data/data/com.terrain.terroot/files/modboot.img ]]
then
    TIMESTAMP="$(date +"%Y%m%d%H%M%S")"
    SCRIPT="/data/local/tmp/root/recboot_script.sh"

    # build script
    echo "#!/system/bin/sh" > ${SCRIPT}
    echo "/system/bin/dd if=/data/data/com.terrain.terroot/files/modboot.img of=/dev/block/mmcblk0 bs=512 seek=557056" >> ${SCRIPT}
    echo "/system/bin/sync" >> ${SCRIPT}

    # execute as root
    /data/local/tmp/root/run_root_shell -c "(chmod 777 ${SCRIPT}) && ${SCRIPT}"
else
    echo "assets needed"
fi

echo "recboot script finished"