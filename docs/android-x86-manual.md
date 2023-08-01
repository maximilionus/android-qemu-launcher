# About
This ROM is originally what this launcher started with and is therefore fully supported. However, after installation you need to do some tweaking if you want to get the full Android VM feature set - for example ARM support. It is also based on the old Android 9.0, making it difficult to use for the modern tasks and overall stability for graphical tasks is quite terrible.


# Downloads
> **Warning**  
> Only the versions from the list below have been tested with this launcher. You are free to use whatever version you want, but any kind of issues may occur.

> **Note**  
> You can find all the official releases for this ROM [here](https://www.android-x86.org/download)

- `9.0-r2` (Android 9.0) - [GAPPS](https://sourceforge.net/projects/android-x86/files/Release%209.0/android-x86_64-9.0-r2.iso/download)


# Install
Installation is quite easy, just follow the [basic guide](../README.md#install). You can also read the more detailed [official installation docs](https://www.android-x86.org/installhowto.html) of this ROM.


# Extra
## ARM Support
> **Warning**  
> For this method to work, you should install your system in **read/write** mode. You're basically asked to do so on the installer, right after formatting the drive.


### Automatic
1. Start the Android emulator with [main script](../launcher.sh).
2. Inside emulator, go to **Settings App -> Android x86 Options**, switch on the **Enable native bridge** and wait before automatic download+install finish (Check notifications for result).
3. Try launching the ARM app. If everything works fine - congratulations! If not - proceed to the [guide below](#extra).


### Extra
> **Note**  
> Below are instructions for those who have not been able to get the arm translator to work in auto-setup mode.

1. Install the requirements:
   - [android-tools](https://developer.android.com/tools/releases/platform-tools)

2. [Download](http://dl.android-x86.org/houdini/9_y/houdini.sfs) the **x86_64 -> ARM** translation and put it somewhere you know. Rename the downloaded file from `houdini.sfs` to `houdini9_y.sfs`. 
   > **Note**  
   > Replace the `<DOWNLOAD_DIR>` with real path in steps below.

3. Follow the [main guide](../README.md#android-debug-bridge-adb) to enable the `adb`.

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

8.  That's it, now reboot the emulator, and you're ready to go:
    ```sh
    reboot -f
    ```
