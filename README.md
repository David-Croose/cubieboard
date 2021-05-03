# Tour of Cubieboard

## 1    What Cubieboard has:

1.  SOC:      AllWinner SOC A10, ARM® Cortex™-A8，1GHz, ARM® Mali 400 complies with OpenGL ES 2.0/1.1
2.  Memory:   1GB DDR3@480MHz (960MTPS)
3.  Storage:  NAND Flash, 4GB default, support TSD flash with SDIO interface
4.  TF Card:  Micro SD card slot, up to 32GB
5.  SATA:     Support 2.5 inch HDD/SSD up to 2TB
6.  Display:  HDMI Port A, HDMI V1.4a, support 1080P@60Hz resolution output
7.  Ethernet: 10M/100M RJ45
8.  IR:       Infrared remote receiver Philips standard
9.  Audio:    Support 3.5 headphone jack for Audio output, Support 3.5 jack for Line-In
10. Power:    DCIN 5V@2.5A power, Support USB power input
11. Keys:     Power key, Uboot key for reflashing the ROM
12. LEDs:     Power Led x 1, User Led x 2
13. Extended: I2C, SPI, RGB/LVDS for LCD, CSI/TS for camera, FM-IN, ADC, CVBS output, VGA, SPDIF-OUT, RTP, and some more

## 2    Before start

toolchain: gcc version 5.4.1 20170404 (Linaro GCC 5.4-2017.05)

## 3    Building uboot

```
# official uboot
$ tar -xf u-boot-2021.01.tar.bz2
$ cd u-boot-2021.01
$ make ARCH=arm Cubieboard_defconfig
$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
```

## 4    Building linux

```
# official linux
$ tar -xf linux-3.18.29.tar.gz
$ cd linux-3.18.29
$ make ARCH=arm sunxi_defconfig
$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
```

This version of linux, however, if you wanna run Debian, you must add these to your `arch/arm/configs/sunxi_defconfig`:

```
CONFIG_AUTOFS4_FS=y
CONFIG_CGROUPS=y
CONFIG_FHANDLE=y
```

## 5    Burning image

Actions below burns uboot, linux and rootfs(Buildroot) into TF card, and make sure the FEL key is not pressed during reboot for Cubieboard boots from TF card.

```
$ ln -s </path/to/u-boot-sunxi-with-spl.bin> uboot
$ ln -s </path/to/zImage> zImage
$ ln -s </path/to/sun4i-a10-cubieboard.dtb> sun4i-a10-cubieboard.dtb
$ ./pack.sh 
==================================================================
Please enter your sdcard block device name:
e.g. /dev/sdb
<input your TF card device name>
...
please enter your rootfs full name:
default is rootfs.tar of buildroot
<Input Enter>
...
==================================================================
extracting rootfs...
==================================================================
unmounting sdcard...
```

Now, insert TF card, reboot the board, enjoy.

## Others

[http://www.cubietech.com/product-detail/cubieboard1/](cubieboard_website)