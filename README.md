## About
Utility and documentation to run hardware-accelerated x86_64 Android images on Linux QEMU KVM

## Supported ROM
This list contains the names of Android images that are officially supported and tested with this launcher and have their own manuals in this repository, under the [docs](./docs/) directory.

- Bliss OS : [Manual](./docs/bliss-os-manual.md)
- Android x86 : [Manual](./docs/android-x86-manual.md)


## Install
### Requirements
- Qemu
- [Virtio](https://www.linux-kvm.org/page/Virtio) drivers (Installed as a Qemu dependency in most package managers by default)


### Steps
> **Note**  
> If your ROM is [officially supported](#supported-rom) by this launcher, then be sure to read the manuals in the [docs](./docs/) directory.

1. Clone this repository
   > **Note**  
   > Yes, you can simply download this repo, but using git is the preferred way if you want to get all the new updates from the upstream.

   ```sh
   git clone https://github.com/maximilionus/android-qemu-launcher.git
   ```
2. Download the desired Android image, but prefer the [officially supported](#supported-rom) one.
3. Run the [launcher](./launcher.sh) with argument `init` to prepare the file structure and drives for VM:
   > **Warning**  
   > Be ready to provide user input.

   ```sh
   ./launcher.sh init
   ```

   Output:
   ```sh
   Directories initialized.
   Enter VM drive size (default: 20G): [USER-INPUT]
   Formatting './drives/...', [...]
   Everything is done [...]
   ```

4. Run the [launcher](./launcher.sh) with the **install** argument and the path to the Android image from step 2 next to it and proceed with basic Android installation on MBR (DOS) drive layout and GRUB bootloader enabled:
   ```sh
   ./launcher.sh install <PATH_TO_ROM>

   # Example
   ./launcher.sh install ~/Downloads/android-x86-rom.iso
   ```

5. Shut down the virtual machine after the installer reports a successful installation, do not reboot it.

6. That's it. From now on, you can run the [launcher](./launcher.sh) to start the VM:
   ```sh
   ./launcher.sh

   # or

   ./launcher.sh run
   ```


## Update
To update the launcher, simply use this command
```sh
git pull
```


## Configuration
### Default
The default configuration file is located in the root of this project and is named [`vm.conf`](./vm.conf). It contains all modifiable variables with their corresponding descriptions and default values. Every value in this file can be changed or even deleted at any point in the development process, so you should prefer using the user configuration file to make any tweaks.

### User
This configuration file must be created manually by the user and placed in the root of this project under the name `vm.user.conf`. Launcher will automatically load it on each run, overwriting the modified variables from the [default configuration](#default).

#### Example
1. Create the `vm.user.conf` in the root of this project.
2. Add modified CPU and RAM values to it. It should look something like this:
   ```
   RAM_SIZE=8192
   CPU_CORES=8
   ADB_ENABLE=true
   ```
3. Now VM will be allowed to use **8 CPU cores**, **8GB of RAM** and **Android Debug Bridge port forwarding enabled** on each start.

> **Note**  
> You can also modify the path to the user configuration file by changing the `CUSTOM_CONFIG_PATH` variable value in the [default configuration](#default).


## Desktop Entry
This project provides a convenient way to manage the desktop entry for the [launcher](./launcher.sh), making it easier to access from your desktop environment.

### Prerequisites
- A desktop environment that supports `.desktop` entries *(e.g., GNOME, KDE, Xfce, etc.)*.
- `GNU Make` utility installed on your system.

### Usage
- To create the desktop entry:
  ```bash
  make install
  ```

- To remove the desktop entry:
  ```bash
  make uninstall
  ```


## Android Debug Bridge (adb)
Virtual Machine can also be accessed with `adb` from the host machine, but this feature is disabled by default in [configuration file](./vm.conf). To enable it, follow the steps below.

1. Create the [user configuration file](#user).
2. Add the `ADB_ENABLE=true` variable to it.
   > **Note**  
   > You can also change the port forwarding by adding the `ADB_PORT=VALUE`.
3. Launch the VM and ensure that [**Developer mode**](https://developer.android.com/studio/debug/dev-options#enable) with [**USB Debugging**](https://developer.android.com/studio/debug/dev-options#Enable-debugging) are enabled.
4. Now you can connect to the VM with `adb` by executing the command below:
   ```sh
   adb connect localhost:4444
   ```
   If you are connecting for the first time, you will be prompted to allow debugging in the VM. Allow the connection and run the command above again.
