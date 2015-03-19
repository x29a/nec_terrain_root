adb push busybox /data/local/tmp/
adb push su /data/local/tmp/
adb push run_root_shell /data/local/tmp/
adb push setup_busybox.sh /data/local/tmp/
adb shell "chmod 777 /data/local/tmp/run_root_shell"
adb install Superuser.apk
adb shell /data/local/tmp/run_root_shell -c "/data/local/tmp/setup_busybox.sh"
