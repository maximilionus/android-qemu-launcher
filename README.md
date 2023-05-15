# Qemu: Android x86_64 9: GPU
Everything you need, to run Android on Linux with hardware acceleration.

## Steps
### Prepare
- Qemu (🫠)
- [Virtio](https://www.linux-kvm.org/page/Virtio) paravirtualized drivers *(Probably are already installed with qemu)*
- [android-tools](https://developer.android.com/tools/releases/platform-tools)

### Main
1. Download the Android x86_64 iso by [this link](https://sourceforge.net/projects/android-x86/files/Release%209.0/android-x86_64-9.0-r2.iso/download) and place it in `./images/`
2. Create the new virtual drive by running the script in `./drives/create-disk`
   > **Note**  
   > Edit the `20G` max. size to your preferring. The disk is allocated dynamically, so it occupies the allowed space only when needed.
3. Launch the [installer script](./vm-install.sh) and procceed with [basic Android x86_64 installation](https://www.android-x86.org/installhowto.html) with GPT layout

   *Example*
   ```
   Number Start    End      Sectors  Size   Code   Name
   1       2048   1050623   1048576   512M  0700      EFI
   2    1050624  41943006  40892383  19.4G  0700  ANDROID
   ```
4. Shut down the virtual machine after the installer reports a successful installation
5. That's it. From now on you can run the main launch script to start the VM
   ```sh
   ./vm-run.sh
   ```

### (Optional) ARM Support
> **Note**  
> For this method to work, you should install your system in **read/write** mode. You're basically asked to do so on the installer, right after formatting the drive

1. [Download](http://dl.android-x86.org/houdini/9_y/houdini.sfs) the **x86_64 -> ARM** translation.
2. Rename the downloaded file to `houdini9_y.sfs` and place it in `./patches/`
3. Start the Android emulator with [main run script](./vm-run.sh)
4. Inside emulator, go to **Settings App -> Android x86 Options** and switch on the **Enable native bridge**
5. Ensure that **Developer mode** with **USB Debugging** are enabled
6. Connect to emulator with **adb**
   ```sh
   adb connect localhost:4444
   ```
   Output:
   ```Log
   connected to localhost:4444
   ```
7. Use **adb** to push the translation file to device
   ```sh
   adb push ./patches/houdini9_y.sfs /sdcard/arm/
   ```
   Output:
   ```Log
   ./patches/houdini9_y.sfs: 1 file pushed, 0 skipped. 351.3 MB/s (42778624 bytes in 0.116s)
   ```
8. Connect to device shell and request SU
   ```sh
   adb shell
   ```
   ```sh
   su
   ```
9. Execute the built-in script to patch the `/system/`
   ```sh
   enable_nativebridge
   ```
   > **Note**  
   > Script does not provide any echo output, which means that after it completes and does not return an error code is a success

10. That's it, now reboot the emulator and you're ready to go
    ```sh
    reboot -f
    ```
