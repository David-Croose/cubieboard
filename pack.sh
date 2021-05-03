#!/bin/bash

set -e

umount_all()
{
	set +e

	df | grep ${SDCARD}1 2>&1 1>/dev/null
	if [ $? == 0 ]; then
		umount ${SDCARD}1
	fi

	df | grep ${SDCARD}2 2>&1 1>/dev/null
	if [ $? == 0 ]; then
		umount ${SDCARD}2
	fi

	set -e
}

UBOOT=uboot
KERN=zImage
DTB=sun4i-a10-cubieboard.dtb

echo "=================================================================="
echo "Please enter your sdcard block device name:"
echo "e.g. /dev/sdb"
read SDCARD

echo "=================================================================="
echo "umounting sdcard..."
umount_all

echo "=================================================================="
echo "deleting all partitions..."
wipefs -a -f $SDCARD
# TODO  can this really work?
dd if=/dev/zero of=$SDCARD bs=1M count=1

echo "=================================================================="
echo "writing uboot into sdcard..."
dd if=$UBOOT of=$SDCARD bs=1024 seek=8

echo "=================================================================="
echo "creating partitions..."
fdisk $SDCARD < part.txt

echo "=================================================================="
echo "formating partitions..."
mkfs.fat ${SDCARD}1
mkfs.ext4 -F ${SDCARD}2

echo "=================================================================="
echo "mounting sdcard..."
rm -rf /tmp/mnt1 /tmp/mnt2
mkdir /tmp/mnt1 /tmp/mnt2
umount_all
mount ${SDCARD}1 /tmp/mnt1
mount ${SDCARD}2 /tmp/mnt2

echo "=================================================================="
echo "copying kernel and dtb..."
cp $KERN $DTB /tmp/mnt1
cp uboot.env /tmp/mnt1

echo "=================================================================="
echo "copying rootfs..."
echo "please enter your rootfs full name:"
echo "default is rootfs.tar of buildroot"
read ROOTFS
if [ -z "$ROOTFS" ]; then
	ROOTFS=rootfs.tar
fi

echo "=================================================================="
echo "extracting rootfs..."
tar -xf $ROOTFS -C /tmp/mnt2

echo "=================================================================="
echo "unmounting sdcard..."
umount_all
rm -rf /tmp/mnt1 /tmp/mnt2
