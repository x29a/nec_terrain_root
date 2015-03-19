#!/bin/bash
while read PACKAGE
do
    echo $PACKAGE
    # first run without root to kill the package if its running
    adb shell "pm disable $PACKAGE"
    # then run with root to disable it
    adb shell "su -c 'pm disable $PACKAGE'"
done < packages-to-disable.list
