#!/bin/bash

set -e

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
elif [ "$1" = "init" ]; then
    mkdir "./drives" "./images"
    echo "Directories initialized."
    read -p "Enter VM drive size (default: 20G): " qemu_drive_size
    qemu_drive_size="${size:-20G}"
    qemu-img create -f qcow2 ./drives/android-x86.qcow2.img $qemu_drive_size
    echo -e "\nEverything is done. Now you should download the Android x86_64 image"
    echo "and place it in the \"./images\". Now launch this scipt with"
    echo "\"install\" argument to start the VM install process."
    echo
    echo "Link to Android x86_64 9:"
    echo "  https://sourceforge.net/projects/android-x86/files/Release%209.0/android-x86_64-9.0-r2.iso/download"
    exit 0
elif [ "$1" = "help" ]; then
    echo "Usage: ./vm.sh [COMMAND]"
    echo
    echo "COMMANDS:"
    echo "  run       : (Default) Run the Virtual Machine in normal mode."
    echo "  init      : Prepare everything for VM, initialize drives."
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
