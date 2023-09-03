# Drive image (qcow2) managing utilities


__driveutils_load_modules () {
    echo "[ Loading the kernel modules ]"
    exec_with_retry "modprobe -v nbd max_part=8" "" "[ Can load the kernel modules. Shutting down. ]"
}

__driveutils_unload_modules () {
    echo "[ Unloading the kernel modules ]"
    exec_with_retry "rmmod -v nbd" "" "[ Can not unload the kernel modules. Shutting down. ]"
}

__driveutils_nbd_connect () {
    echo "[ Connecting the drive to NBD ]"
    exec_with_retry "qemu-nbd --connect=/dev/nbd0 $DRIVE_PATH" "" "[ Can not connect the drive to NBD server. Shutting down. ]"
}

__driveutils_nbd_disconnect () {
    echo "[ Disconnecting the drive from NBD ]"
    exec_with_retry "qemu-nbd --disconnect /dev/nbd0" "" "[ Can not disconnect the drive from NBD server. Shutting down. ]"
}

__driveutils_nbd_mount () {
    echo "[ Mounting the drive image to the '$(realpath $DRIVE_MOUNT_PATH)' directory]"

    tries=1
    max_tries=5
    until mount /dev/nbd0p1 "$DRIVE_MOUNT_PATH"; do
        echo "- Attempting to mount the drive. Attempt: $tries"

        if ((tries >= 5)); then
            echo "[ Can not mount the drive. Shutting down. ]"
            set +e
            __driveutils_nbd_umount
            __driveutils_nbd_disconnect
            __driveutils_unload_modules
            __driveutils_mountdir_delete
            exit 1
        fi

        ((tries++))
        sleep 3
    done

    echo "[ Drive was successfully mounted ]"
}

__driveutils_nbd_umount () {
    echo "[ Unmounting the drive image from the '$(realpath $DRIVE_MOUNT_PATH)' directory]"
    umount -v "$DRIVE_MOUNT_PATH"
    echo "[ Drive was successfully unmounted ]"
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
    require_root

    __driveutils_load_modules
    __driveutils_nbd_connect
    __driveutils_mountdir_create
    __driveutils_nbd_mount
}

# Unmount the drive and unload the kernel modules
driveutils_umount () {
    require_root

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
        echo ""
        echo "NOTES:"
        echo "  The \"mount\" and \"umount\" commands require root privileges"
        echo "  to execute."
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
