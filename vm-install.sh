#!/bin/bash
qemu-system-x86_64 \
-name "Android x86_64 VM - Install" \
-enable-kvm \
-M q35 \
-m 4096 -smp 4 -cpu host \
-drive file=./drives/android-x86.qcow2.img,if=virtio \
-cdrom ./images/android-x86_64-9.0-r2.iso \
-usb \
-device virtio-tablet \
-device virtio-keyboard \
-device qemu-xhci,id=xhci \
-device virtio-vga-gl \
-display sdl,gl=on \
-machine vmport=off \
-net nic,model=virtio-net-pci -net user,hostfwd=tcp::4444-:5555
