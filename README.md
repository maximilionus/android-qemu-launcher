# Android in Qemu on GPU
## About
Manuals and scripts to run **Android x86_64 9.0** on Linux with hardware acceleration and ARM translation.


## Install
### Requirements  
- Qemu
- [Virtio](https://www.linux-kvm.org/page/Virtio) paravirtualized drivers


### Steps
1. Run the [main script](./vm.sh) with argument `init` to prepare file structure and drives for VM:
   > **Note**  
   > Be ready to provide the user input to prompts.

   ```sh
   ./vm.sh init
   ```

   Output:
   ```sh
   Directories initialized.
   Enter VM drive size (default: 20G): [USER-INPUT]
   Formatting './drives/android-x86.qcow2.img', [...]
   Everything is done [...]
   ```

2. [Download](https://sourceforge.net/projects/android-x86/files/Release%209.0/android-x86_64-9.0-r2.iso/download) the Android x86_64 image and follow the instructions from the previous command output.

3. Run the [main script](./vm.sh) in **install** mode and proceed with [basic Android x86_64 installation](https://www.android-x86.org/installhowto.html) with MBR layout:
   ```sh
   ./vm.sh install
   ```

4. Shut down the virtual machine after the installer reports a successful installation.

5. That's it. From now on, you can run the main launch script to start the VM:
   ```sh
   ./vm.sh

   # or

   ./vm.sh run
   ```


## Post-Install
### ARM Support
> **Warning**  
> For this method to work, you should install your system in **read/write** mode. You're basically asked to do so on the installer, right after formatting the drive.


#### Automatic
1. Start the Android emulator with [main script](./vm.sh).
2. Inside emulator, go to **Settings App -> Android x86 Options**, switch on the **Enable native bridge** and wait before automatic download+install finish (Check notifications for result).
3. Try launching the ARM app. If everything works fine - congratulations! If not - proceed to the [guide below](#extra).


#### Extra
> **Note**  
> Below are instructions for those who have not been able to get the arm translator to work in auto-setup mode.

1. Install the requirements:
   - [android-tools](https://developer.android.com/tools/releases/platform-tools)

2. [Download](http://dl.android-x86.org/houdini/9_y/houdini.sfs) the **x86_64 -> ARM** translation and put it somewhere you know. Rename the downloaded file from `houdini.sfs` to `houdini9_y.sfs`. 
   > **Note**  
   > Replace the `<DOWNLOAD_DIR>` with real path in steps below.

3. Ensure that [**Developer mode**](https://developer.android.com/studio/debug/dev-options#enable) with [**USB Debugging**](https://developer.android.com/studio/debug/dev-options#Enable-debugging) are enabled in Android.

4. Connect to emulator with **adb**:
   ```sh
   adb connect localhost:4444
   ```
   *Output:*
   ```Log
   connected to localhost:4444
   ```

5. Use **adb** to push the translation file to device:
   ```sh
   adb push <DOWNLOAD_DIR>/houdini9_y.sfs /sdcard/arm/
   ```
   *Output:*
   ```Log
   <DOWNLOAD_DIR>/houdini9_y.sfs: 1 file pushed, 0 skipped. 351.3 MB/s (42778624 bytes in 0.116s)
   ```

6. Connect to device shell and request **SU**:
   ```sh
   adb shell
   ```
   ```sh
   su
   ```

7.  Execute the built-in script to patch the `/system/`:
   ```sh
   enable_nativebridge
   ```
   > **Note**  
   > Script does not provide any echo output, which means that after it completes and does not return an error code is a success

8. That's it, now reboot the emulator, and you're ready to go:
    ```sh
    reboot -f
    ```
