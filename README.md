# Android Qemu Launcher
## About
Manuals and scripts to run **Android** on Linux with hardware acceleration and other stuff.


## Install
### Requirements  
- Qemu
- [Virtio](https://www.linux-kvm.org/page/Virtio) drivers


### Steps
1. Run the [main script](./launcher.sh) with argument `init` to prepare file structure and drives for VM:
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

2. Download the desired Android image and follow the instructions from the previous command output.

3. Run the [main script](./launcher.sh) with **install** argument and proceed with basic Android installation with MBR *(Not GPT)* drive layout and GRUB bootloader enabled:
   ```sh
   ./launcher.sh install
   ```
   > **Note**  
   > If your ROM is in the officially supported by this launcher list, then be sure to read the manuals in [docs](./docs/) directory.

4. Shut down the virtual machine after the installer reports a successful installation, do not reboot it.

5. That's it. From now on, you can run the main launch script to start the VM:
   ```sh
   ./launcher.sh

   # or

   ./launcher.sh run
   ```


## Extra
### Configuration
The configuration file is located in the root of this project and is named [`vm.conf`](./vm.conf). It contains all the modifiable values with description. Change with caution, every value in this file can be changed or even deleted.
