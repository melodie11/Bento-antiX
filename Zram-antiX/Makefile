# Makefile for ZRAM_antiX
#
# Variables
DESTDIR ?= /
DEFAULT_DIR = /etc/default
INITD_DIR = /etc/init.d
PREFIX = /usr/local
APPS_DIR = /usr/share/applications

# Files to install (paths relative to the project root)
DEFAULT_CONF = etc/default/zram
INIT_SCRIPT = etc/init.d/zram
GUI_SCRIPT = usr/local/bin/toggle-zram-gui.sh
DESKTOP_FILE = usr/share/applications/zram-control.desktop
POST_INSTALL_SCRIPT = post-install

all:
	@echo "Type 'make install' to install ZRAM control scripts and configuration."
	@echo "Type 'make uninstall' to remove them."

# Installation target
install: copy_files permissions register_service update_db
	@echo "Installation of ZRAM components complete."

# Copies files from source to their destination within the system hierarchy
copy_files:
	@echo "Copying files..."
	cp $(DEFAULT_CONF) $(DESTDIR)$(DEFAULT_DIR)/zram
	cp $(INIT_SCRIPT) $(DESTDIR)$(INITD_DIR)/zram
	cp $(GUI_SCRIPT) $(DESTDIR)$(PREFIX)/bin/toggle-zram-gui.sh
	cp $(DESKTOP_FILE) $(DESTDIR)$(APPS_DIR)/zram-control.desktop

# Sets the appropriate file permissions for installed files
permissions:
	@echo "Setting file permissions..."
	chmod 644 $(DESTDIR)$(DEFAULT_DIR)/zram           # Configuration file
	chmod 755 $(DESTDIR)$(INITD_DIR)/zram             # Init script needs executable permission
	chmod 755 $(DESTDIR)$(PREFIX)/bin/toggle-zram-gui.sh # GUI script needs executable permission
	chmod 644 $(DESTDIR)$(APPS_DIR)/zram-control.desktop # Desktop file

# Registers the ZRAM service using the post-install script
register_service:
	@echo "Registering ZRAM service..."
	# The post-install script is responsible for running update-rc.d or similar
	# and handling ZRAM setup (e.g., enabling/starting the service).
	# Ensure this script is executable and handles the DESTDIR if packaging.
	$(DESTDIR)$(POST_INSTALL_SCRIPT)

# Updates the desktop file database for application menus
update_db:
	@echo "Updating desktop database..."
	update-desktop-database $(DESTDIR)$(APPS_DIR)

# Uninstallation target
uninstall: unregister_service remove_files update_db
	@echo "Uninstallation complete. You may need to reboot or log out/in."

# Unregisters the ZRAM service
unregister_service:
	@echo "Unregistering ZRAM service..."
	# '|| true' prevents the make process from failing if the service isn't found
	update-rc.d zram remove || true

# Removes the installed files from the system
remove_files:
	@echo "Removing installed files..."
	rm -f $(DESTDIR)$(DEFAULT_DIR)/zram
	rm -f $(DESTDIR)$(INITD_DIR)/zram
	rm -f $(DESTDIR)$(PREFIX)/bin/toggle-zram-gui.sh
	rm -f $(DESTDIR)$(APPS_DIR)/zram-control.desktop

# Help message for users
help:
	@echo "Makefile for ZRAM_antiX project."
	@echo ""
	@echo "Usage:"
	@echo "  make install     - Installs ZRAM scripts, configuration, and desktop entry."
	@echo "  make uninstall   - Removes ZRAM components."
	@echo "  make clean       - (No files to clean for this project, just an empty target for convention)"
	@echo ""
	@echo "To install to a specific root directory (for packaging):"
	@echo "  make install DESTDIR=/path/to/staging/root"
