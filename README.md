# Android Qemu Launcher
## About
Launcher and manuals to run **Android** images (x86_64 architecture) on Linux natively with hardware acceleration and other stuff.

## Supported ROM
This list contains the names of Android images that are officially supported and tested with this launcher and have their own manuals in this repository, under the [docs](./docs/) directory.

- Bliss OS : [Manual](./docs/bliss-os-manual.md)
- Android x86 : [Manual](./docs/android-x86-manual.md)


## Install
### Requirements
- Qemu
- [Virtio](https://www.linux-kvm.org/page/Virtio) drivers


### Steps
> **Note**  
> If your ROM is in the officially supported by this launcher list, then be sure to read the manuals in [docs](./docs/) directory.
1. Clone this repository
   > **Note**  
   > Yes, you can simply download this repo, but using git is more preferred way if you want get all the new updates from the upstream.

   ```sh
   git clone https://github.com/maximilionus/android-qemu-launcher.git
   ```
2. Download the desired Android image, but prefer the [officially supported](#supported-rom) one.
3. Run the [launcher](./launcher.sh) with argument `init` to prepare the file structure and drives for VM:
   > **Warning**  
   > Be ready to provide the user input.

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

4. Run the [launcher](./launcher.sh) with **install** argument and the path to the Android image from step 2 next to it and proceed with basic Android installation on MBR *(Not GPT!)* drive layout and GRUB bootloader enabled:
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


## Extra
### Configuration

#### Default
The default configuration file is located in the root of this project and is named [`vm.conf`](./vm.conf). It contains all modifiable variables with the corresponding description and default values. Every value in this file can be changed or even deleted at any point of the development, so you should prefer using the user configuration file to make any tweaks.

#### User
This configuration file must be created manually by the user and placed in the root of this project under the name `vm.user.conf`. Launcher will automatically load it on each run, overwriting the modified variables from the [default config](#default).

> **Exapmle**  
> 1. Create the `vm.user.conf` in the root of this project.
> 2. Add modified CPU and RAM values to it. It should look something like this:
>    ```
>    RAM_SIZE=8192
>    CPU_CORES=8
>    ```
> 3. Now VM will be allowed to use **8 CPU** cores and **8GB of RAM** on each start.

> **Note**  
> You can also modify the path to user configuration file by chaning the `CUSTOM_CONFIG_PATH` variable in [`vm.conf`](./vm.conf)
