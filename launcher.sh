#!/bin/bash

# Exit on first error
set -e

# Change the workdir to the script location
cd "$(dirname "$0")"

# Load the configuration files
. ./vm.conf

if [ -f "$CUSTOM_CONFIG_PATH" ]; then
    . $CUSTOM_CONFIG_PATH
fi

# Load modules
source ./modules/core.sh
source ./modules/drive-utils.sh

# Default args for qemu
arguments_list=(
    "-enable-kvm"
    "-M" "q35"
    "-m" "$RAM_SIZE"
    "-smp" "$CPU_CORES"
    "-cpu" "host"
    "-drive" "file=$DRIVE_PATH,if=virtio"
    "-usb"
    "-device" "virtio-tablet"
    "-device" "virtio-keyboard"
    "-device" "qemu-xhci,id=xhci"
    "-device" "virtio-vga-gl"
    "-display" "sdl,gl=on"
    "-machine" "vmport=off"
    "-net" "nic,model=virtio-net-pci"
)

# Add config-based args
if [ "$ADB_ENABLE" = true ] ; then
    arguments_list+=("-net" "user,hostfwd=tcp::$ADB_PORT-:5555")
else
    arguments_list+=("-net" "user")
fi

# Process params
# TODO: Split implementation to module
if ([ $# -eq 0 ] || [ "$1" = "run" ]); then
    # Launch the VM in default mode
    arguments_list+=(
        "-name" "$WINDOW_TITLE"
        "-audio" "pa,model=ac97"
    )
    echo "Starting the VM in normal mode"
elif [ "$1" = "install" ]; then
    # Launch installation mode
    if [ -z "$2" ]; then
        echo "Error: No path to Android image provided. Exiting."
        exit 1
    fi

    arguments_list+=(
        "-name" "$WINDOW_TITLE - Install"
        "-cdrom" "$2"
    )

    echo "Starting the VM in installation mode"
    echo
    echo "Please read the manual in ./docs/ for your ROM if its"
    echo "officially supported by this launcher"
    echo
    echo "NOTE: Be sure to select the MBR (DOS) layout for the drive with"
    echo "      ext4 formatting and GRUB bootloader enabled."
elif [ "$1" = "init" ]; then
    # Initialize file structure for this launcher
    mkdir -p -v $(dirname "$DRIVE_PATH")

    echo "Directories initialized."
    read -p "Enter VM drive size (default: 20G): " _qemu_drive_size
    _qemu_drive_size="${_qemu_drive_size:-20G}"
    qemu-img create -f qcow2 "$DRIVE_PATH" $_qemu_drive_size

    echo
    echo "Everything is done. Now you should download the desired"
    echo "Android (x86_64 arch) image and launch this scipt with \"install\""
    echo "argument, providing the path to the image."
    echo
    echo "EXAMPLE:"
    echo "  ./launcher.sh install ~/Downloads/downloaded-android-image.iso"
    exit 0
elif [ "$1" = "drive" ]; then
    driveutils_cli_process_args "${@:2}"
elif [ "$1" = "d_args" ]; then
    echo "Composed arguments array:"
    echo "${arguments_list[@]}"
    exit 0
elif [ "$1" = "help" ]; then
    # Show help messages
    echo "Usage: ./launcher.sh [COMMAND]"
    echo
    echo "COMMANDS:"
    echo "  run             : (Default) Run the Virtual Machine in normal mode."
    echo "  init            : Prepare everything for VM, initialize drives."
    echo "  install <IMAGE> : Run the Virtual Machine in installation mode with"
    echo "                    <IMAGE> path to the Android image to be"
    echo "                    installed."
    echo "  drive <CMD>     : Set of utilities to manage the VM drive."
    echo "  help            : Show this help message."
    echo
    echo "DEBUG COMMANDS:"
    echo "  d_args          : Print the composed array of arguments and exit."
    echo
    echo "NOTES:"
    echo "  \"(Default)\" argument will be selected automatically, if no arguments"
    echo "  are provided to the script."
    exit 0
else
    echo "Error: Invalid argument: $1"
    exit 1
fi

qemu-system-x86_64 "${arguments_list[@]}"
