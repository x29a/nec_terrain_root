#!/system/bin/sh
exec 2>&1

echo "reboot script start"

if [[ -x /data/local/tmp/root/run_root_shell ]]
then
    # execute as root
    /data/local/tmp/root/run_root_shell -c "reboot"
else
    echo "assets needed"
fi

echo "reboot script finished"