#!/system/bin/sh
exec 2>&1


echo "deploy script start"


if [[ -f /data/data/com.terrain.terroot/files/run_root_shell && -f /data/data/com.terrain.terroot/files/parted && -f /data/data/com.terrain.terroot/files/sgdisk && -f /data/data/com.terrain.terroot/files/modboot.img ]]
then
    /data/data/com.terrain.terroot/files/run_root_shell -c "mkdir -p /data/local/tmp/root/ && chmod -R 777 /data/local/tmp/root/"

    cat /data/data/com.terrain.terroot/files/run_root_shell > /data/local/tmp/root/run_root_shell
    cat /data/data/com.terrain.terroot/files/parted > /data/local/tmp/root/parted
    cat /data/data/com.terrain.terroot/files/sgdisk > /data/local/tmp/root/sgdisk

    chmod 777 /data/local/tmp/root/*
    chmod 777 /data/data/com.terrain.terroot/files/modboot.img
else
    echo "assets needed"
fi

echo "deploy script finished"