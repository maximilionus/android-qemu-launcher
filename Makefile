APP_NAME := Android Qemu Launcher
ENTRY_NAME := android-qemu-launcher
SCRIPT_NAME := launcher.sh
ICON_PATH := data/icons/desktop_icon.svg
DEST_DIR := $(HOME)/.local/share/applications
.DEFAULT_GOAL := help

install:
	@echo "[Desktop Entry]" > $(DEST_DIR)/$(ENTRY_NAME).desktop
	@echo "Name=$(APP_NAME)" >> $(DEST_DIR)/$(ENTRY_NAME).desktop
	@echo "Exec=$(realpath $(SCRIPT_NAME))" >> $(DEST_DIR)/$(ENTRY_NAME).desktop
	@echo "Icon=$(realpath $(ICON_PATH))" >> $(DEST_DIR)/$(ENTRY_NAME).desktop
	@echo "Type=Application" >> $(DEST_DIR)/$(ENTRY_NAME).desktop
	@echo "Categories=Graphics;" >> $(DEST_DIR)/$(ENTRY_NAME).desktop

	@echo "Desktop entry created successfully."

uninstall:
	rm -f $(DEST_DIR)/$(ENTRY_NAME).desktop

	@echo "Desktop entry removed successfully."

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  install       Install the desktop entry."
	@echo "  uninstall     Remove the desktop entry."
	@echo "  help          Display this help message."
