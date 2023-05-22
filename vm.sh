#!/bin/bash

values=(
    "-enable-kvm"
    "-M" "q35"
    "-m" "4096"
    "-smp" "4"
    "-cpu" "host"
    "-drive" "file=./drives/android-x86.qcow2.img,if=virtio"
    "-usb"
    "-device" "virtio-tablet"
    "-device" "virtio-keyboard"
    "-device" "qemu-xhci,id=xhci"
    "-device" "virtio-vga-gl"
    "-display" "sdl,gl=on"
    "-machine" "vmport=off"
    "-net" "nic,model=virtio-net-pci"
    "-net" "user,hostfwd=tcp::4444-:5555"

)

if ([ $# -eq 0 ] || [ "$1" = "run" ]); then
    values+=(
        "-name" "\"Android x86_64\""
        "-audiodev" "pa,id=snd0"
        "-device" "AC97,audiodev=snd0"
    )
    echo "Starting the VM in normal mode"
elif [ "$1" = "install" ]; then
    values+=(
        "-name" "\"Android x86_64 - Install\""
        "-cdrom" "./images/android-x86_64-9.0-r2.iso"
    )
    echo "Starting the VM in installation mode"
elif [ "$1" = "help" ]; then
    echo "Usage: ./vm.sh [COMMAND]"
    echo
    echo "COMMANDS:"
    echo "  run       : (Default) Run the Virtual Machine in normal mode."
    echo "  install   : Run the Virtual Machine in installation mode."
    echo "  help      : Show this help message."
    echo
    echo "NOTES:"
    echo "  \"(Default)\" argument will be selected automatically, if no arguments"
    echo "  are provided to script."
    exit 0
else
    echo "Invalid argument: $1"
    exit 1
fi

qemu-system-x86_64 "${values[@]}"
