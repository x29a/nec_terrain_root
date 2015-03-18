#!/bin/bash

adb push create_scripts.sh /data/local/tmp/
adb shell /data/local/tmp/create_scripts.sh
adb pull /data/local/tmp/get_partitions.sh
# use su here in case adb shell is not auto-root (via adbd insecure)
adb shell "su -c /data/local/tmp/dd_partitions.sh"

/bin/bash get_partitions.sh
