# Android in Qemu on GPU
## About
Manuals and scripts to run **Android x86_64 9.0** on Linux with hardware acceleration and ARM translation.


## Install
### Requirements  
- Qemu
- [Virtio](https://www.linux-kvm.org/page/Virtio) paravirtualized drivers


### Steps
1. Download the Android x86_64 iso by [this link](https://sourceforge.net/projects/android-x86/files/Release%209.0/android-x86_64-9.0-r2.iso/download) and place it in `./images/`
2. Create the new virtual drive by running the script in `./drives/create-disk`
   > **Note**  
   > Edit the `20G` max. size to your preferring. The disk is allocated dynamically, so it occupies the allowed space only when needed.
3. Launch the [installer script](./vm-install.sh) and procceed with [basic Android x86_64 installation](https://www.android-x86.org/installhowto.html) with MBR layout
4. Shut down the virtual machine after the installer reports a successful installation
5. That's it. From now on you can run the main launch script to start the VM
   ```sh
   ./vm-run.sh
   ```


## Post-Install
### ARM Support
> **Warning**  
> For this method to work, you should install your system in **read/write** mode. You're basically asked to do so on the installer, right after formatting the drive


#### Requirements
- [android-tools](https://developer.android.com/tools/releases/platform-tools)


#### Automatic
1. [Download](https://github.com/maximilionus/android-x86_64-qemu-hwaccel/raw/files/x86_64-arm-bridge/android-9.0/houdini9_y.sfs) *([mirror](http://dl.android-x86.org/houdini/9_y/houdini.sfs))* the **x86_64 -> ARM** translation and place it in `./patches/` directory
   > **Note**  
   > If the file was downloaded from a *mirror*, rename it to `houdini9_y.sfs`
2. Start the Android emulator with [main run script](./vm-run.sh)
3. Inside emulator, go to **Settings App -> Android x86 Options**, switch on the **Enable native bridge** and wait before automatic download+install finish (Check notifications for result).
4. Try launching the ARM app. If everything works fine - congratulations! If not - proceed to the guide below.


#### Extra
> **Warning**  
> Below are instructions for those who have not been able to get the arm translator to work in auto-setup mode.

1. Ensure that [**Developer mode**](https://developer.android.com/studio/debug/dev-options#enable) with [**USB Debugging**](https://developer.android.com/studio/debug/dev-options#Enable-debugging) are enabled in Android
2. Connect to emulator with **adb**
   ```sh
   adb connect localhost:4444
   ```
   *Output:*
   ```Log
   connected to localhost:4444
   ```
3. Use **adb** to push the translation file to device
   ```sh
   adb push ./patches/houdini9_y.sfs /sdcard/arm/
   ```
   *Output:*
   ```Log
   ./patches/houdini9_y.sfs: 1 file pushed, 0 skipped. 351.3 MB/s (42778624 bytes in 0.116s)
   ```
4. Connect to device shell and request SU
   ```sh
   adb shell
   ```
   ```sh
   su
   ```
5.  Execute the built-in script to patch the `/system/`
   ```sh
   enable_nativebridge
   ```
   > **Note**  
   > Script does not provide any echo output, which means that after it completes and does not return an error code is a success

6. That's it, now reboot the emulator and you're ready to go
    ```sh
    reboot -f
    ```
