## UPDATE
root is achieved! See [Terroot](terroot/README.md) and alex-kas (https://github.com/alex-kas/nec_terrain and http://forum.xda-developers.com/showpost.php?p=61542922&postcount=186). After this method has been tested and verified, the next steps are: fully open recovery, optimized kernel, nice ROM. Feel free to chip in!

----------------------------------------------------------------------------------------------------


This is a repo for collecting information on attempts to gain permanent root on the NEC Terrain mobile phone.

Feel free to send me pull-requests, direct messages or write me over on xda-developers! Any help appreciated!

The NEC Terrain (NE-201A1A) is an Android Phone (updated to 4.0.4, kernel 3.0.8) with a physical keyboard. It is currently sold by AT&T (https://www.att.com/cellphones/nec/terrain.html#sku=sku6610548) and there is an (carrier) unlocked version available at Amazon (http://www.amazon.com/NEC-Terrain-UNLOCKED-WaterProof-DustProof/dp/B00KZPI04S/).

Hardware specs can be found all over the net, e.g. on GSM Arena (http://www.gsmarena.com/nec_terrain-5553.php).

Unfortunately, the phone comes with a lot of pre-installed Apps (Bloatware), which is one reason why various efforts have been made to gain full root access. A possible workaround (via pm disable) is presented later.

The current state seems to be, that one can gain temporary root access but cannot write to any partitions (for permanent root) because they are NAND locked. This is similar to the bootloader mode S-ON, known from HTC. Since NEC stopped making mobile phones, chances are basically non-existing that they will offer an unlock service like Sony or HTC.

AT&T claims (via various contact attempts by xda-developer users) that they cannot provide any (bootloader) unlock keys. Maybe, if more people asked?

The recovery (e3) can be accessed via the following procedure:
* Shutdown phone
* Hold volume-down button while pressing the power-on button
* An android on his back with an open belly should appear (maintenance)
* Press volume-up, then volume-down to enter recovery
* Navigate via volume-down, select via volume-up

The menu entries "repair software by sdcard" and "maintenance" are locked via an ~~un~~known code, consisting of only numbers and possible 10 digits long.

The code for maintenance has been found, it is based on the IMEI of the phone, which can be found under the battery. From the IMEI, the code can be constructed by combining the digits in the following way:

* 2nd digit
* last three digits
* 3rd and 4th digit
* 01

so if the IMEI was the following 

0489000000567 

(not a real IMEI), the code would be

45678901

Though, nothing useful was found with the maintance mode yet.

There is an option in the Android menu called "AT&T Software Update" but all phones seem to be delivered with the update already installed (https://www.att.com/esupport/article.jsp?sid=KB421350).

The "Check for Updates" option establishes a HTTPS connection to 166.216.149.131.

The "Software Update by SD card" option expects an update.dat file on the (real) SD card and reboots to recovery, very similar to the "repair software by sdcard" option directly available in recovery.

Temporary root access can be gained via the run_root_shell binary (https://github.com/android-rooting-tools/android_run_root_shell).

Needed for the scripts to work is a working ADB connection (https://developer.android.com/tools/help/adb.html), so be sure to enable "USB Debugging" on the phone. The scripts are currently written for Linux, but making Windows Batch files out of them should not be a problem. The scripts prefixed with "adb_*" are run locally on the host and call scripts on the target (NEC Terrain) via adb.

UPDATE: some of the scripts were ported to Windows Batch files, so instead of calling "adb_install_bb_su.sh", one would call "adb_install_bb_su.bat". For ADB to work on Windows, special drivers might be required (https://developer.android.com/tools/extras/oem-usb.html). Instead of downloading the whole SDK, one can find the basic tools as well (e.g. http://forum.xda-developers.com/showthread.php?t=2588979). Scripts are untested, feel free to test and improve!

Fastboot existance and access is unknown so far, although there exist some instructions (http://forum.xda-developers.com/android/help/nec-terrain-root-maybe-t2946966).

Since the build.prop setting ro.secure is set to 1, the adbd on the phone will not allow an "adb root" from the host. This can be (temporarily) changed on a phone with temp root via ADBD Insecure (http://forum.xda-developers.com/showthread.php?t=1687590).

To gain temporary root on the phone, just execute the "adb_install_bb_su.sh" script from the folder "temporary_root"

```
$ adb devices
List of devices attached 
123a0815    device
$ adb shell
shell@android:/ $ su
/system/bin/sh: su: not found
shell@android:/ $ exit
$ cd temporary_root
$ ./adb_install_bb_su.sh
$ adb shell
shell@android:/ $ su
shell@android:/ # exit
```
Now one can install SuperSU (http://download.chainfire.eu/supersu) and ADBD Insecure, either from Google Play market or via `adb install`.

With busybox and su in place, reading the partitions is quite easy by executing the "adb_pull_partitions.sh" script. Be aware, writing the images to "/mnt/sdcard/images" takes around 15 minutes (and requires around 3GB of free space there). Afterwards, the pulling of the images from the target to the host also takes 15min. So a total of 20 to 30 minutes is not atypical.

```
$ cd pull_partitions
$ ./adb_pull_partitions.sh
.
.
.
$ du -sh images/
2,8G    images/
```

Maybe someone can do some magic and disable the NAND lock or extract information on how the update.dat file should look?

Since removing unwanted applications ~~is currently~~was not possible, one can at least disable them (to permanently remove them, see [Terroot](terroot/README.md)). This script is inspired by a couple of scripts provided in one of the mentioned threads (http://forum.xda-developers.com/showpost.php?p=58675054&postcount=17) but it does not install XPosed framework or change other settings. Some of what the script does could also be done manually in the "Apps" menu by clicking on each app and selecting "Disable".

 Root is needed (so run "adb_install_bb_su.sh" from "temporary_root" beforehand) for the commands to switch the state to disabled, without root, the packages would just be killed. The changes (aka applications missing from menu) should be effective after a reboot.

```
$ cd disable_apps
$ ./adb_disable_apps.sh
```

The "packages.list" gives an overview of installed packages, adding package names (without the package: prefix as seen from `adb shell "pm list packages"`) to "packages-to-disable.list" will disable them with the next run of "adb_disable_apps.sh". The "packages_apk.list" file (generated via `adb shell "pm list packages -f"`) also gives the APK name for the packages, for better orientation. If you remove important packages, the phone might not be able to start and fall into a boot loop. Use `adb lolcat` to see what might be the issue. If you must, you can always wipe cache/factory reset via the recovery.

Links on Bloatware and apps to remove:
* http://blog.burrowsapps.com/2014/03/what-android-apps-are-safe-to-remove.html
* http://wiki.cyanogenmod.org/w/Template:Barebones
* http://forum.xda-developers.com/showthread.php?t=1528945

XDA-Developer forum links specifically for the NEC Terrain:
* http://forum.xda-developers.com/general/help/towelroot-nec-terrain-ive-thinking-t2852052 Root method discovered for NEC Terrain?
* http://forum.xda-developers.com/showthread.php?t=2515602 Unlocking of NEC Terrain SIM/Root 
* http://forum.xda-developers.com/showthread.php?t=2337642 NEC Terrain: ADB/CDC Serial Driver, 3e Recovery Password, and Root
* http://forum.xda-developers.com/android/help/how-to-roor-nec-terrain-ne-201a1a-t2882552 How to roor NEC Terrain NE-201A1A
* http://forum.xda-developers.com/general/help/nec-terrain-rooting-flashing-guide-t2814730 NEC Terrain Rooting and Flashing Guide
* http://forum.xda-developers.com/showthread.php?t=2683123 Rooting NEC Terrain

General topics dealing with similar issues:
* http://forum.xda-developers.com/showthread.php?t=2500826 huge and lots of info
* http://forum.xda-developers.com/showthread.php?t=2642207 knox method
* http://forum.xda-developers.com/showthread.php?t=1338073 hardware approach
* http://forum.xda-developers.com/showthread.php?t=2292157 loki bootloader exploit

Different NEC Models:
* http://forum.xda-developers.com/showthread.php?t=1230611
* http://forum.xda-developers.com/showthread.php?t=2607778

Qualcomm related
* http://forum.xda-developers.com/showthread.php?t=2641245 IDA Pro

Links for building custom boot files:
* http://whiteboard.ping.se/Android/Rooting
* https://android.stackexchange.com/questions/28653/obtaining-root-by-modifying-default-propro-secure


