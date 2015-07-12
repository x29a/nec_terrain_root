#!/system/bin/sh
exec 2>&1

echo "su script start"

if [[ -x /data/local/tmp/root/run_root_shell && -f /data/data/com.terrain.terroot/files/su ]]
then
    SCRIPT="/data/local/tmp/root/su_script.sh"

    # build script
    echo "#!/system/bin/sh" > ${SCRIPT}
    echo "cat /data/data/com.terrain.terroot/files/su > /system/xbin/su" >> ${SCRIPT}
    echo "chmod 6755 /system/xbin/su" >> ${SCRIPT}
    echo "chmod 777 /data/data/com.terrain.terroot/files/superuser.apk" >> ${SCRIPT}
    echo "pm install /data/data/com.terrain.terroot/files/superuser.apk" >> ${SCRIPT}
    echo "/system/bin/sync" >> ${SCRIPT}

    # execute as root
    /data/local/tmp/root/run_root_shell -c "(chmod 777 ${SCRIPT}) && ${SCRIPT}"
else
    echo "assets needed"
fi

echo "su script finished"