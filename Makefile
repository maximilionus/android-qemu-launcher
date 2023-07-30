APP_NAME := Android Qemu VM
ENTRY_NAME := com.maximilionus.AndroidQemuVM
SCRIPT_NAME := launcher.sh
ICON_PATH := data/icons/desktop_icon.svg
DEST_DIR := $(HOME)/.local/share/applications

install:
	@echo "[Desktop Entry]" > $(DEST_DIR)/$(ENTRY_NAME).desktop
	@echo "Name=$(APP_NAME)" >> $(DEST_DIR)/$(ENTRY_NAME).desktop
	@echo "Exec=$(realpath $(SCRIPT_NAME))" >> $(DEST_DIR)/$(ENTRY_NAME).desktop
	@echo "Icon=$(realpath $(ICON_PATH))" >> $(DEST_DIR)/$(ENTRY_NAME).desktop
	@echo "Type=Application" >> $(DEST_DIR)/$(ENTRY_NAME).desktop
	@echo "Categories=Utility;" >> $(DEST_DIR)/$(ENTRY_NAME).desktop

	@echo "Desktop entry created successfully."

uninstall:
	rm -f $(DEST_DIR)/$(ENTRY_NAME).desktop

	@echo "Desktop entry removed successfully."
