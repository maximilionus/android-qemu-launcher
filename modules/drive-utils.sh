__driveutils_load_modules () {
    echo "[ Loading the kernel modules ]"
    modprobe -v nbd max_part=8
}

__driveutils_unload_modules () {
    echo "[ Unloading the kernel modules ]"
    rmmod -v nbd
}

__driveutils_nbd_connect () {
    echo "[ Connecting the drive to NBD ]"
    qemu-nbd --connect=/dev/nbd0 $DRIVE_PATH
}

__driveutils_nbd_disconnect () {
    echo "[ Disconnecting the drive from NBD ]"
    qemu-nbd --disconnect /dev/nbd0
}

__driveutils_nbd_mount () {
    echo "[ Mounting the drive image to the '$(realpath $DRIVE_MOUNT_PATH)' directory]"
    mount /dev/nbd0p1 "$DRIVE_MOUNT_PATH"
}

__driveutils_nbd_umount () {
    echo "[ Unmounting the drive image from the '$(realpath $DRIVE_MOUNT_PATH)' directory]"
    umount -v "$DRIVE_MOUNT_PATH"
}

__driveutils_mountdir_create () {
    echo "[ Creating the mount dir ]"
    mkdir -v -p "$DRIVE_MOUNT_PATH"
}

__driveutils_mountdir_delete () {
    echo "[ Removing the mount dir ]"
    rm -rfv "$DRIVE_MOUNT_PATH"
}


# Load kernel modules and mount the drive to a local folder inside the root
# of current project
driveutils_mount () {
    mount_tries=1
    __driveutils_load_modules
    __driveutils_nbd_connect
    __driveutils_mountdir_create

    until __driveutils_nbd_mount; do
        echo "Attempting to mount the drive. Attempt: $mount_tries"

        if ((mount_tries >= 5)); then
            echo "[ Can not mount the drive. Shutting down. ]"
            set +e
            __driveutils_nbd_umount
            __driveutils_nbd_disconnect
            __driveutils_unload_modules
            __driveutils_mountdir_delete
            exit 1
        fi

        ((mount_tries++))
        sleep 2
    done

    echo "[ Drive was successfully mounted to the '$(realpath $DRIVE_MOUNT_PATH)' directory ]"
}

# Unmount the drive and unload the kernel modules
driveutils_umount () {
    __driveutils_nbd_umount
    __driveutils_nbd_disconnect
    __driveutils_unload_modules
    __driveutils_mountdir_delete
}

# Process the CLI args
driveutils_cli_process_args () {
    arguments_arr=("${@}")

    if ([ $# -eq 0 ] || [ "${arguments_arr[0]}" = "help" ]); then
        echo "Usage: ./launcher.sh drive [COMMAND]"
        echo "About: Set of utilities to manage the VM drive."
        echo
        echo "COMMANDS:"
        echo "  help   : (Default) Show this help message."
        echo "  mount  : Mount the VM drive to the path provided with"
        echo "           'DRIVE_MOUNT_PATH' var in the configuration file."
        echo "  umount : Unmount the VM drive and unload all modules."
    elif ([ "${arguments_arr[0]}" == "mount" ]); then
        driveutils_mount
    elif ([ "${arguments_arr[0]}" == "umount" ]); then
        driveutils_umount
    else
        echo "Error: Invalid argument: \"${arguments_arr[0]}\""
        exit 1
    fi

    exit 0
}
