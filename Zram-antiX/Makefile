# Makefile for ZRAM_antiX
#
# Variables
DESTDIR ?= /
PREFIX = /usr/local
INITD_DIR = /etc/init.d
DEFAULT_DIR = /etc/default
APPS_DIR = /usr/share/applications

# Files to install
INIT_SCRIPT = etc/init.d/zram
DEFAULT_CONF = etc/default/zram
GUI_SCRIPT = usr/local/bin/toggle-zram-gui.sh
DESKTOP_FILE = usr/share/applications/zram-control.desktop
POST_INSTALL_SCRIPT = post-install

# Target directories
INSTALL_INITD_DIR = $(DESTDIR)$(INITD_DIR)
INSTALL_DEFAULT_DIR = $(DESTDIR)$(DEFAULT_DIR)
INSTALL_GUI_DIR = $(DESTDIR)$(PREFIX)/bin
INSTALL_APPS_DIR = $(DESTDIR)$(APPS_DIR)

.PHONY: all install uninstall clean help

all:
	@echo "Type 'make install' to install ZRAM control scripts and configuration."
	@echo "Type 'make uninstall' to remove them."

install: directories copy_files permissions register_service update_db clean_polkit

directories:
	@echo "Creating installation directories..."
	mkdir -p $(INSTALL_INITD_DIR)
	mkdir -p $(INSTALL_DEFAULT_DIR)
	mkdir -p $(INSTALL_GUI_DIR)
	mkdir -p $(INSTALL_APPS_DIR)

copy_files:
	@echo "Copying files..."
	cp $(INIT_SCRIPT) $(INSTALL_INITD_DIR)/zram
	cp $(DEFAULT_CONF) $(INSTALL_DEFAULT_DIR)/zram
	cp $(GUI_SCRIPT) $(INSTALL_GUI_DIR)/toggle-zram-gui.sh
	cp $(DESKTOP_FILE) $(INSTALL_APPS_DIR)/zram-control.desktop

permissions:
	@echo "Setting file permissions..."
	chmod 755 $(INSTALL_INITD_DIR)/zram
	chmod 755 $(INSTALL_GUI_DIR)/toggle-zram-gui.sh
	# Configuration file and desktop file don't need executable bits
	chmod 644 $(INSTALL_DEFAULT_DIR)/zram
	chmod 644 $(INSTALL_APPS_DIR)/zram-control.desktop

register_service:
	@echo "Registering ZRAM service with update-rc.d..."
	$(DESTDIR)$(POST_INSTALL_SCRIPT) # Execute your existing post-install script

update_db:
	@echo "Updating desktop database..."
	update-desktop-database $(INSTALL_APPS_DIR) # Specify directory for safety

clean_polkit:
	@echo "Cleaning up Polkit rule for gksu..."
	rm -f $(DESTDIR)/etc/polkit-1/rules.d/05-zram-no-root-password.rules
	@if [ -x "$(DESTDIR)/usr/lib/polkit-1/polkitd" ]; then \
	    echo "Restarting Polkit daemon..."; \
	    $(DESTDIR)/usr/lib/polkit-1/polkitd --no-debug & \
	else \
	    echo "Polkit daemon not found, skipping restart."; \
	fi

uninstall: unregister_service remove_files clean_polkit_uninstall update_db
	@echo "Uninstallation complete. You may need to reboot or log out/in."

unregister_service:
	@echo "Unregistering ZRAM service with update-rc.d..."
	update-rc.d zram remove || true # '|| true' to avoid error if not registered

remove_files:
	@echo "Removing installed files..."
	rm -f $(INSTALL_INITD_DIR)/zram
	rm -f $(INSTALL_DEFAULT_DIR)/zram
	rm -f $(INSTALL_GUI_DIR)/toggle-zram-gui.sh
	rm -f $(INSTALL_APPS_DIR)/zram-control.desktop

clean_polkit_uninstall:
	@echo "Cleaning up Polkit rule during uninstall..."
	# This should ideally be done by the post-install/post-remove script of the package
	# but added here for completeness if manual uninstall.
	rm -f $(DESTDIR)/etc/polkit-1/rules.d/05-zram-no-root-password.rules
	@if [ -x "$(DESTDIR)/usr/lib/polkit-1/polkitd" ]; then \
	    echo "Restarting Polkit daemon..."; \
	    $(DESTDIR)/usr/lib/polkit-1/polkitd --no-debug & \
	else \
	    echo "Polkit daemon not found, skipping restart."; \
	fi

help:
	@echo "Makefile for ZRAM_antiX project."
	@echo ""
	@echo "Usage:"
	@echo "  make install     - Installs ZRAM scripts, configuration, and desktop entry."
	@echo "  make uninstall   - Removes ZRAM components."
	@echo "  make clean       - (No files to clean for this project)"
	@echo ""
	@echo "To install to a specific root directory (for packaging):"
	@echo "  make install DESTDIR=/path/to/staging/root"

