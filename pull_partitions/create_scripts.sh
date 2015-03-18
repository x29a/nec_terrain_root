#!/system/bin/sh

# this script will run on a phone with temporary root and 
# generate the needed scripts for getting the partition images

# config
DDSCRIPT=dd_partitions.sh
GETSCRIPT=get_partitions.sh
SOURCE=/dev/block
# the images will be around 2.8G which should fit on this empty path
TARGET=/mnt/sdcard/images
SLEEPTIME=1

cd /data/local/tmp/

mkdir -p $TARGET

# dd script on device
echo "#!/system/bin/sh" > $DDSCRIPT
echo "echo 'calling dd a lot now...'" >> $DDSCRIPT
echo "echo 'cancel with ctrl+c when space runs out...'" >> $DDSCRIPT

# get script on host
echo "#!/bin/bash" > $GETSCRIPT
echo "mkdir -p images && cd images" >> $GETSCRIPT

# iterate over all partitions
for i in `seq 1 31`;
do
    DEVICE=mmcblk0p$i
    NAME=`cat /sys/block/mmcblk0/$DEVICE/* 2>&1 | grep -v "invalid length" | grep "PARTNAME" | sed 's/PARTNAME=//'`
    
    echo "echo '#################################'" >> $DDSCRIPT
    echo "echo 'partition: $NAME - id: $i'" >> $DDSCRIPT
    
    # do not dump out memory card where we are currently writing to
    if ! [ $i -eq 14 ]; then        
        echo "dd if=$SOURCE/$DEVICE of=$TARGET/part.$(printf %02d $i).$NAME" >> $DDSCRIPT
        echo "df $TARGET" >> $DDSCRIPT
        echo "sleep $SLEEPTIME" >> $DDSCRIPT
        echo "adb pull $TARGET/part.$i.$NAME" >> $GETSCRIPT
    else
        echo "echo 'skipped'" >> $DDSCRIPT
    fi
done

echo "echo '#################################'" >> $DDSCRIPT
echo "echo 'all done...'" >> $DDSCRIPT

chmod 777 $DDSCRIPT
chmod 777 $GETSCRIPT
