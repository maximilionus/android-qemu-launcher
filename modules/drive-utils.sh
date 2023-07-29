# Load kernel modules and mount the drive to a local folder inside the root
# of current project
driveutils_mount () {
    echo "Loading the kernel modules"
    modprobe -v nbd max_part=8

    echo "Mounting the disk image"
    qemu-nbd --connect=/dev/nbd0 $DRIVE_PATH
    mkdir -v $DRIVE_MOUNT_PATH
    mount /dev/nbd0p1 $DRIVE_MOUNT_PATH

    echo "Drive was successfully mounted to the '$(realpath $DRIVE_MOUNT_PATH)' directory"
}

# Unmount the drive and unload the kernel modules
driveutils_umount () {
    echo "Unmounting the drive image"
    umount /dev/nbd0p1
    qemu-nbd --disconnect /dev/nbd0

    echo "Unloading the kernel modules and removing the temp mount dir"
    rmmod -v nbd
    rm -rfv $DRIVE_MOUNT_PATH
    echo "Drive was successfully unmounted from the '$(realpath $DRIVE_MOUNT_PATH)' directory"
}

# Process the CLI args
driveutils_cli_process_args () {
    arguments_arr=("${@}")

    if ([ "${arguments_arr[0]}" == "mount" ]); then
        driveutils_mount
    elif ([ "${arguments_arr[0]}" == "umount" ]); then
        driveutils_umount
    fi

    exit 0
}
