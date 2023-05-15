#!/bin/bash

set -e
umount ./mnt
qemu-nbd --disconnect /dev/nbd0
rmmod nbd
rm -rfv ./mnt
echo "Done"
