#!/bin/bash

set -e
modprobe nbd max_part=8
qemu-nbd --connect=/dev/nbd0 ./android-x86.qcow2.img
mkdir ./mnt
mount /dev/nbd0p2 ./mnt
echo "Done"
