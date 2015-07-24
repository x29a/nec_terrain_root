#!/system/bin/sh
exec 2>&1

echo "kas.boot script start"

if [[ -x /data/local/tmp/root/run_root_shell && -x /data/local/tmp/root/sgdisk && -f /data/data/com.terrain.terroot/files/kas.boot.bin ]]
then
    TIMESTAMP="$(date +"%Y%m%d%H%M%S")"
    SCRIPT="/data/local/tmp/root/kas_boot_script.sh"

    # build script
    echo "#!/system/bin/sh" > ${SCRIPT}
    echo "mkdir -p /mnt/external_sd/brnects0.715" >> ${SCRIPT}
    echo "cat /data/data/com.terrain.terroot/files/kas.boot.bin > /mnt/external_sd/brnects0.715/kas.boot.bin" >> ${SCRIPT}
    echo "/system/bin/sync" >> ${SCRIPT}

    # execute as root
    /data/local/tmp/root/run_root_shell -c "(chmod 777 ${SCRIPT}) && ${SCRIPT}"

else
    echo "assets needed"
fi

echo "kas.boot script finished"