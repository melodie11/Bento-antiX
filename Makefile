############################ INFORMATION ######################################

## The Bento Openbox setup is a bundle of configuration files along with 
## information meant to ease the use of the Openbox Window Manager, and
## altogether forming a solid while also light environment for the desktop. 
## To know more, please consult the lovely README provided with the sources. :)

## Authors:
## Joyce MARKOLL <contact@orditux.org> (aka Mélodie), 
## Fabrice THIROUX <fabrice.thiroux@free.fr>, and many more contributors. 

## This setup is free software: you can redistribute it and/or modify it
## under the terms of the GNU GPLv3 as published by the Free Software
## Foundation, either version 3 of the License, or any later version, unless 
## some parts belong to another projects with their own free licence. As far
## as we know all of them are provided under a licence compatible this the 
## <https://www.gnu.org/licenses>. 
## The images are our creation, and can also be reused under the terms of the 
## GNU GPLv3 licence.

## This bundle is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU GPLv3 License for more details.

## You should have received a copy of the GNU GPLv3 License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.


###############################################################################

## THIS IS THE SETUP FOR Bento antiX 32 bits built on antiX Core 23.2 i486

## How to use this Makefile
#  To install, type `make install` from within the root directory of the bundle,
#  with the administration rights.
#  To remove, type `make uninstall` also using administration rights.

SHELL := /bin/bash

# Base Destination Directory (for packaging support)
DESTDIR ?= /

# Standard FHS Destination Directories
ETC_DIR = $(DESTDIR)/etc
USR_DIR = $(DESTDIR)/usr
VAR_LIB_DIR = $(DESTDIR)/var/lib

# Specific Sub-Directories under /etc
ETC_LIGHTDM_DIR = $(ETC_DIR)/lightdm
ETC_LIGHTDM_CONF_D_DIR = $(ETC_LIGHTDM_DIR)/lightdm.conf.d
ETC_POLKIT_RULES_D_DIR = $(ETC_DIR)/polkit-1/rules.d
ETC_SKEL_DIR = $(ETC_DIR)/skel
ETC_SUDOERS_D_DIR = $(ETC_DIR)/sudoers.d
ETC_XDG_DIR = $(ETC_DIR)/xdg
ETC_XDG_AUTOSTART_DIR = $(ETC_XDG_DIR)/autostart
ETC_XDG_MENUS_DIR = $(ETC_XDG_DIR)/menus

# Specific Sub-Directories under /usr
USR_LOCAL_BIN_DIR = $(USR_DIR)/local/bin
USR_SHARE_DIR = $(USR_DIR)/share
USR_SHARE_BENTO_DIR = $(USR_SHARE_DIR)/bento
USR_SHARE_ICONS_DIR = $(USR_SHARE_DIR)/icons
USR_SHARE_THEMES_DIR = $(USR_SHARE_DIR)/themes

# --- Files to Install (Source paths relative to project root './' based on ls -lR) ---

# Files under ./etc/ (top level)
ETC_TOP_LEVEL_FILES_SRC = \
	etc/environment \
	etc/inittab

# Files under ./etc/lighdm/lightdm.conf.d/
LIGHTDM_CONF_FILES_SRC = \
	etc/lighdm/lightdm.conf.d/01_debian.conf \
	etc/lighdm/lightdm.conf.d/0_bento.conf \
	etc/lighdm/lightdm.conf.d/lightdm.conf \
	etc/lighdm/lightdm.conf.d/lightdm-gtk-greeter.conf

# Files under ./etc/polkit-1/rules.d/
POLKIT_RULES_FILES_SRC = \
	etc/polkit-1/rules.d/20-Udisks2-filesystem-mount.rules \
	etc/polkit-1/rules.d/30-policykit-pkexec-auth.rules \
	etc/polkit-1/rules.d/40-gparted-sudo-auth.rules \
	etc/polkit-1/rules.d/50-lightdm-gtk-greeter-settings.rules \
	etc/polkit-1/rules.d/60-synaptic-sudo-auth.rules \
	etc/polkit-1/rules.d/70-power-management-sudo-users.rules

# Files under ./etc/sudoers.d/
SUDOERS_D_FILES_SRC = \
	etc/sudoers.d/keep_qt_env

# Files under ./etc/xdg/autostart/
XDG_AUTOSTART_FILES_SRC = \
	etc/xdg/autostart/connman-gtk.desktop \
	etc/xdg/autostart/cp-minstall-launcher.desktop \
	etc/xdg/autostart/fix-network-live.desktop \
	etc/xdg/autostart/welcome-information.desktop

# Files under ./etc/xdg/menus/
XDG_MENUS_FILES_SRC = \
	etc/xdg/menus/applications.menu

# Files under ./usr/local/bin/ (scripts and binary)
USR_LOCAL_BIN_FILES_SRC = \
	usr/local/bin/bento-antix.desktop.sh \
	usr/local/bin/fix-network-live.sh \
	usr/local/bin/openbox-menu \
	usr/local/bin/welcome.sh \
	usr/local/bin/xcompmgr.sh \
	usr/local/bin/xsnow.sh

# --- Installation Targets ---

all:
	@echo "Type 'make install' to install Bento antiX components."
	@echo "Type 'make uninstall' to remove them."

install: copy_files set_permissions setup_lightdm_data update_desktop_db
	@echo "Installation of Bento antiX components complete."

# Copies all files and directories from the source tree to their destinations
copy_files:
	@echo "Copying files and directories..."

	# Copy top-level /etc files
	install -m 644 $(ETC_TOP_LEVEL_FILES_SRC) $(ETC_DIR)/

	# Copy Lightdm config files
	install -D -m 644 $(LIGHTDM_CONF_FILES_SRC) $(ETC_LIGHTDM_CONF_D_DIR)/

	# Copy Polkit rules files
	install -D -m 644 $(POLKIT_RULES_FILES_SRC) $(ETC_POLKIT_RULES_D_DIR)/

	# Copy sudoers.d file
	install -D -m 644 $(SUDOERS_D_FILES_SRC) $(ETC_SUDOERS_D_DIR)/

	# Copy XDG autostart files
	install -D -m 644 $(XDG_AUTOSTART_FILES_SRC) $(ETC_XDG_AUTOSTART_DIR)/

	# Copy XDG menus file
	install -D -m 644 $(XDG_MENUS_FILES_SRC) $(ETC_XDG_MENUS_DIR)/

	# Copy usr/local/bin scripts/binaries
	install -D -m 755 $(USR_LOCAL_BIN_FILES_SRC) $(USR_LOCAL_BIN_DIR)/

	# Copy recursive directories using rsync to handle contents
	# etc/skel/ to $(ETC_SKEL_DIR)
	# Use || true so make doesn't fail if source /etc/skel is truly empty.
	rsync -rl etc/skel/ $(ETC_SKEL_DIR) || true

	# usr/share/bento/ to $(USR_SHARE_BENTO_DIR)
	rsync -rl usr/share/bento/ $(USR_SHARE_BENTO_DIR)

	# usr/share/icons/ to $(USR_SHARE_ICONS_DIR)
	rsync -rl usr/share/icons/ $(USR_SHARE_ICONS_DIR)

	# usr/share/themes/ to $(USR_SHARE_THEMES_DIR)
	# Use || true so make doesn't fail if source /usr/share/themes is truly empty.
	rsync -rl usr/share/themes/ $(USR_SHARE_THEMES_DIR) || true

# Set appropriate permissions for files/directories that were copied recursively by rsync,
# or those needing more specific rules.
set_permissions:
	@echo "Setting specific file permissions..."
	# Permissions for etc/skel content (assuming dotfiles exist and need specific perms)
	# These chmod commands will not fail if files are not present after rsync on empty source,
	# due to the '|| true' or shell behavior for non-existent files.
	chmod a+x $(ETC_SKEL_DIR)/.config/openbox/scripts/oblocale.sh || true
	chmod a+x $(ETC_SKEL_DIR)/.config/openbox/lang/autostart-* || true
	
	# Set permissions for files and directories copied under /usr/share/bento
	find $(USR_SHARE_BENTO_DIR) -type f -exec chmod 644 {} \;
	find $(USR_SHARE_BENTO_DIR) -type d -exec chmod 755 {} \;

	# Set permissions for files and directories copied under /usr/share/icons
	find $(USR_SHARE_ICONS_DIR) -type f -exec chmod 644 {} \;
	find $(USR_SHARE_ICONS_DIR) -type d -exec chmod 755 {} \;

	# Set permissions for files and directories copied under /usr/share/themes
	find $(USR_SHARE_THEMES_DIR) -type f -exec chmod 644 {} \; || true
	find $(USR_SHARE_THEMES_DIR) -type d -exec chmod 755 {} \; || true

	# Ensure /etc/skel itself and its subdirectories have correct permissions
	find $(ETC_SKEL_DIR) -type d -exec chmod 755 {} \;

# Setup Lightdm data directory
setup_lightdm_data:
	@echo "Setting up Lightdm data directory..."
	mkdir -p $(VAR_LIB_DIR)/lightdm/data
	chown lightdm:lightdm $(VAR_LIB_DIR)/lightdm/data
	chmod 750 $(VAR_LIB_DIR)/lightdm/data

# Updates the desktop file database for application menus
update_desktop_db:
	@echo "Updating desktop database..."
	# update-desktop-database expects the directory containing desktop files.
	# The XDG_AUTOSTART_FILES_SRC are copied to $(ETC_XDG_AUTOSTART_DIR)
	update-desktop-database $(ETC_XDG_AUTOSTART_DIR)
	# Desktop files could also be in /usr/share/applications if they existed there in source.
	# Assuming no files from source need to go into /usr/share/applications directly.
	# If any .desktop files are copied into $(USR_SHARE_ICONS_DIR) or other locations,
	# their parent directories should also be updated if they are part of the desktop menu system.
	# This line is typical for installed .desktop files, keeping it for robustness.
	update-desktop-database $(USR_SHARE_DIR)/applications || true


# --- Uninstallation Targets ---

uninstall: remove_files remove_lightdm_data
	@echo "Uninstallation complete. You may need to reboot or log out/in."

# Removes installed files and directories
remove_files:
	@echo "Removing installed files..."

	# Remove top-level /etc files
	# Use basename of source files to get target file names.
	rm -f $(addprefix $(ETC_DIR)/, $(notdir $(ETC_TOP_LEVEL_FILES_SRC)))

	# Remove Lightdm config files
	rm -f $(addprefix $(ETC_LIGHTDM_CONF_D_DIR)/, $(notdir $(LIGHTDM_CONF_FILES_SRC)))

	# Remove Polkit rules files
	rm -f $(addprefix $(ETC_POLKIT_RULES_D_DIR)/, $(notdir $(POLKIT_RULES_FILES_SRC)))

	# Remove sudoers.d file
	rm -f $(addprefix $(ETC_SUDOERS_D_DIR)/, $(notdir $(SUDOERS_D_FILES_SRC)))

	# Remove XDG autostart files
	rm -f $(addprefix $(ETC_XDG_AUTOSTART_DIR)/, $(notdir $(XDG_AUTOSTART_FILES_SRC)))

	# Remove XDG menus file
	rm -f $(addprefix $(ETC_XDG_MENUS_DIR)/, $(notdir $(XDG_MENUS_FILES_SRC)))

	# Remove usr/local/bin scripts/binaries
	rm -f $(addprefix $(USR_LOCAL_BIN_DIR)/, $(notdir $(USR_LOCAL_BIN_FILES_SRC)))

	# Remove recursive directories (whole trees)
	rm -rf $(USR_SHARE_BENTO_DIR)
	rm -rf $(USR_SHARE_ICONS_DIR)
	rm -rf $(USR_SHARE_THEMES_DIR)
	rm -rf $(ETC_SKEL_DIR)

# Remove Lightdm data directory and its parent if empty
remove_lightdm_data:
	@echo "Removing Lightdm data directory..."
	rm -rf $(VAR_LIB_DIR)/lightdm/data
	# Attempt to remove parent directories if they become empty (rmdir fails if not empty)
	rmdir $(VAR_LIB_DIR)/lightdm 2>/dev/null || true
	rmdir $(VAR_LIB_DIR) 2>/dev/null || true


# --- Help Target ---
help:
	@echo "Makefile for Bento antiX 32-bit."
	@echo ""
	@echo "Usage:"
	@echo "  make install     - Installs Bento antiX components."
	@echo "  make uninstall   - Removes Bento antiX components."
	@echo "  make help        - Displays this help message."
	@echo ""
	@echo "To install to a specific root directory (for packaging):"
	@echo "  make install DESTDIR=/path/to/staging/root"
	
