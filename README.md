# Android Qemu Launcher
## About
Launcher and manuals to run **Android** images *(x86_64 architecture)* on Linux natively with hardware acceleration and other stuff.

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
2. Download the desired Android image.
3. Run the [main script](./launcher.sh) with argument `init` to prepare file structure and drives for VM:
   > **Note**  
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

4. Run the [main script](./launcher.sh) with **install** argument and proceed with basic Android installation with MBR *(Not GPT!)* drive layout and GRUB bootloader enabled:
   ```sh
   ./launcher.sh install
   ```

5. Shut down the virtual machine after the installer reports a successful installation, do not reboot it.

6. That's it. From now on, you can run the main launch script to start the VM:
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
The configuration file is located in the root of this project and is named [`vm.conf`](./vm.conf). It contains all modifiable values with the corresponding description. Modify with caution, every value in this file can be changed or even deleted.
