This app contains all the tools needed to mount /system rw, which is a precondition for a permanent root.

## DISCLAIMER 
This app is provided as a demo for advanced users. No responsibility is taken, it might turn your phone into a brick.

##### with great power comes great responsibility! 

/!\ YOU HAVE BEEN WARNED /!\

Also, this app relies on a special partition layout for step 4 and 5 so be sure your /data/local/tmp/backup/TIMESTAMP_partition_layout.txt (TIMESTAMP being a timestamp from when the backup was taken) looks EXACTLY like this

```
Model: MMC M8G2FB (sd/mmc)
Disk /dev/block/mmcblk0: 7818182656B
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start        End          Size         File system  Name          Flags
 1      16777216B    150994943B   134217728B   fat16        modem
 2      150994944B   218103807B   67108864B                 flashbackup
 3      218103808B   285212671B   67108864B                 fatallog
 4      301989888B   302252031B   262144B                   sbl1
 5      302252032B   302514175B   262144B                   sbl2
 6      302514176B   304611327B   2097152B                  sbl3
 7      304611328B   305135615B   524288B                   aboot
 8      305135616B   305659903B   524288B                   rpm
 9      305659904B   316145663B   10485760B                 boot
10      316145664B   316669951B   524288B                   tz
11      316669952B   327155711B   10485760B                 recovery
12      327155712B   1434451967B  1107296256B  ext4         system
13      1442840576B  2281701375B  838860800B   ext4         userdata
14      2281701376B  6945767423B  4664066048B  fat32        GROW
15      6945767424B  6954156031B  8388608B     ext4         persist
16      6954156032B  7331643391B  377487360B   ext4         cache
17      7331643392B  7405043711B  73400320B    ext4         tombstones
18      7405043712B  7406092287B  1048576B                  misc
19      7406092288B  7406093311B  1024B                     pad
20      7406093312B  7406101503B  8192B                     ssd
21      7406101504B  7409247231B  3145728B                  modemst1
22      7409247232B  7412392959B  3145728B                  modemst2
23      7412392960B  7415538687B  3145728B                  fsg
24      7415538688B  7415800831B  262144B                   sbl2_bkp
25      7415800832B  7417897983B  2097152B                  sbl3_bkp
26      7417897984B  7418422271B  524288B                   aboot_bkp
27      7418422272B  7418946559B  524288B                   rpm_bkp
28      7418946560B  7419470847B  524288B                   tz_bkp
29      7419470848B  7429956607B  10485760B                 recovery_bkp
30      7429956608B  7440442367B  10485760B                 fota_config
31      7440442368B  7675323391B  234881024B   ext4         MM


```

## Installation
The .apk needs to be installed on the phone. This can be achieved in multiple ways, e.g. by downloading it from a webserver, copying it to a mediacard or using "adb install". The option "Unknown sources" under Settings -> Security must be enabled.

## Usage steps
### 1. Copy assets
First, the used binaries and images need to be copied to the right places on the phone. Since the app contains a full modified boot image, it is so huge and might take a little while.

### 2. Backup
In order to have the best chances to fix the system in case something goes wrong, a couple of files are backed up (e.g. the original GPT table and boot/recovery images). The data can be pulled via adb from /data/local/tmp/backup/.

Since system images are pulled, this step can take a while, the GUI might hang.

### 3. Modify partition layout GPT
A small hole in the partition layout is used to remap the recovery partition to a modified boot image, which is written in the last step.

### 4. Write modified boot
The modified boot image is written to the remapped location.

## Rooting
After all steps have been performed, the phone has to be unplugged from USB, then turned off. Now press the volume down button (as if entering recovery) until you see the AT&T logo. Now the custom boot should fire up which enables read/write access to /system.

In order to have permanent root, one needs to install the "su" binary along with some management software like superuser or SuperSU. 

Terroot features a basic version, when booted into readwrite /system, performing step 6 will install su and superuser.apk.

This would be a good time to install a current version of SuperSU and ADBD Insecure from the PlayStore.

Also, removing bloatware is now possible.

To go back to the stock kernel (without r/w on /system), simply reboot the phone.

## Restoring Recovery
Nothing got deleted, so in order to get back into recovery when pushing the volume down button on boot, only the partition table has to be restored, which can be done as root via

/data/local/tmp/root/sgdisk --load-backup=/data/local/tmp/backup/TIMESTAMP_mmcblk0.gpt /dev/block/mmcblk0

Note: the timestamp should be from the original backup made when pushing "backup" in the app for the first time.

## Custom recovery and boot
Thanks to Alex.Kas, there is now a [custom recovery](https://github.com/alex-kas/nec_terrain/blob/master/recovery/README.md) with ADB/root/tools/...

It is very advised to install this recovery in order to be more flexible with system recovery in case anything goes wrong.

Terroot uses the same partition as created in Step 3 above, so the custom boot will be lost, but that is no problem since a [custom boot](https://github.com/alex-kas/nec_terrain/blob/master/boot/README.md) image also exists which lets you remount the /system partition on the fly (no reboot needed anymore!).

### Prerequisites
At this point, the cellphone should be rooted permanently, since the new boot image needs root permissions to remount /system rw. The custom boot process needs a real external microSD card.

### Copying
Use Terroot steps "KASreco" to flash the custom recovery and "KASboot" to prepare the custom boot image (on the real external SD card).

### Installation
Reboot the phone with volume down pressed to enter the new custom recovery (green infotext on black background). At this point, start an adb shell and execute `/rbin/flash_boot.sh`. After it is finished, reboot.

### Verification
Once booted, adb shell into the device, become root (su) and check that /system is mounted ro. Then remount rw and check if writing is possible via

```
shell@android:/ $ su
root@android:/ # mount | grep /system
/dev/block/mmcblk0p12 /system ext4 ro,relatime,user_xattr,barrier=1,data=ordered,discard 0 0
root@android:/ # mount -o remount,rw /system
root@android:/ # mount | grep /system                                          
/dev/block/mmcblk0p12 /system ext4 rw,relatime,user_xattr,barrier=1,data=ordered,discard 0 0
root@android:/ # touch /system/foo && ls -la /system/foo
-rw-rw-rw- root     root            0 1970-01-06 03:21 foo
root@android:/ # rm /system/foo
```

## Troubleshooting
If something goes wrong, you should be always able to normally boot the phone, temporary root it and look at logfiles and the contents of /data/local/tmp. If in doubt, reboot the phone and try the whole procedure again.
