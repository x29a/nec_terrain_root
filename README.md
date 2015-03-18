This is a repo for collecting information on attempts to gain permanent root on the NEC Terrain mobile phone.


The NEC Terrain (NE-201A1A) is an Android Phone (updated to 4.0.4, kernel 3.0.8) with a physical keyboard. It is currently sold by AT&T (https://www.att.com/cellphones/nec/terrain.html#sku=sku6610548) and there is an (carrier) unlocked version available at Amazon (http://www.amazon.com/NEC-Terrain-UNLOCKED-WaterProof-DustProof/dp/B00KZPI04S/).


Hardware specs can be found all over the net, e.g. on GSM Arena (http://www.gsmarena.com/nec_terrain-5553.php).


Unfortunately, the phone comes with a lot of pre-installed Apps (Bloatware), which is one reason why various efforts have been made to gain full root access.


The current state seems to be, that one can gain temporary root access but cannot write to any partitions (for permanent root) because they are NAND locked. This is similar to the bootloader mode S-ON, known from HTC. Since NEC stopped making mobile phones, chances are basically non-existing that they will offer an unlock service like Sony or HTC.


AT&T claims (via various contact attempts by xda-developer users) that they cannot provide any (bootloader) unlock keys. Maybe, if more people asked?


The recovery (e3) can be accessed via the following procedure:
* Shutdown phone
* Hold volume-down button while pressing the power-on button
* An android on his back with an open belly should appear (maintenance)
* Press volume-up, then volume-down to enter recovery
* Navigate via volume-down, select via volume-up

The menu entries "repair software by sdcard" and "maintenance" are locked via an unknown code, consisting of only numbers and possible 10 digits long.


There is an option in the Android menu called "AT&T Software Update" but all phones seem to be delivered with the update already installed (https://www.att.com/esupport/article.jsp?sid=KB421350).


Temporary root access can be gained via the run_root_shell binary (https://github.com/android-rooting-tools/android_run_root_shell).

Needed for the scripts to work is a working ADB connection (https://developer.android.com/tools/help/adb.html). The scripts are currently written for Linux, but making Windows Batch files out of them should not be a problem. The scripts prefixed with "adb_*" are run locally on the host and call scripts on the target (NEC Terrain) via adb.

Since the build.prop setting ro.secure is set to 1, the adbd on the phone will not allow an "adb root" from the host. This can be (temporarily) changed on a phone with temp root via ADBD Insecure (http://forum.xda-developers.com/showthread.php?t=1687590).


To gain temporary root on the phone, just execute the "adb_install.sh" script from the folder "temporary_root"

```
$ adb devices
List of devices attached 
123a0815    device
$ adb shell
shell@android:/ $ su
/system/bin/sh: su: not found
shell@android:/ $ exit
$ cd temporary_root
$ ./adb_install.sh
$ adb shell
shell@android:/ $ su
shell@android:/ # exit
```

Now one can install SuperSU (http://download.chainfire.eu/supersu) and ADBD Insecure, either from Google Play market or via `adb install`.


With busybox and su in place, reading the partitions is quite easy by executing the "adb_pull_partitions.sh" script. Be aware, writing the images to "/mnt/sdcard/images" takes around 15 minutes (and requires around 3GB of free space there). Afterwards, the pulling of the images from the target to the host also takes also 15min. So a total of 20 to 30 minutes is not atypical.

```
$ cd pull_partitions
$ ./adb_pull_partitions.sh
.
.
.
$ du -sh images/
2,8G    images/
```

