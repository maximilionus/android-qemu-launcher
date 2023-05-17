#!/bin/bash
qemu-system-x86_64 \
-name "Android x86_64 VM" \
-enable-kvm \
-M q35 \
-m 4096 -smp 4 -cpu host \
-bios /usr/share/edk2/ovmf/OVMF_CODE.fd \
-drive file=./drives/android-x86.qcow2.img,if=virtio \
-usb \
-device virtio-tablet \
-device virtio-keyboard \
-device qemu-xhci,id=xhci \
-machine vmport=off \
-device virtio-vga-gl -display sdl,gl=on \
-audiodev pa,id=snd0 -device AC97,audiodev=snd0 \
-net nic,model=virtio-net-pci -net user,hostfwd=tcp::4444-:5555
