#!/bin/bash
qemu-system-x86_64 \
-name "Android x86_64 VM" \
-enable-kvm \
-M q35 \
-m 4096 -smp 4 -cpu host \
-drive file=./drives/android-x86.qcow2.img,if=virtio \
-usb \
-device virtio-tablet \
-device virtio-keyboard \
-device qemu-xhci,id=xhci \
-device virtio-vga-gl \
-display sdl,gl=on \
-machine vmport=off \
-audiodev pa,id=snd0 -device AC97,audiodev=snd0 \
-net nic,model=virtio-net-pci -net user,hostfwd=tcp::4444-:5555
