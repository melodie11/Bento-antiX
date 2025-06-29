############################ INFORMATION ######################################

## The Bento Openbox setup for antiXn adapted from our Bento Openbox 
## Remix setup, is a bundle of configuration files along with information
## meant to ease the use of the Openbox Window Manager, and
## altogether forming a solid while also light environment for the 
## desktop. To know more, please consult the lovely README provided with
## the sources. :)

## Authors:
## Joyce MARKOLL <contact@orditux.org> (aka Mélodie), 
## Fabrice THIROUX <fabrice.thiroux@free.fr>, and many more contributors. 

## This setup is free software: you can redistribute it and/or modify it
## under the terms of the GNU GPLv3 as published by the Free Software
## Foundation, either version 3 of the License, or any later version, 
## unless some parts belong to another projects with their own free 
## licence. As far as we know all of them are provided under a licence
## compatible this the  <https://www.gnu.org/licenses>. 
## The images are our creation, and can also be reused under the terms 
## of the GNU GPLv3 licence.

## This bundle is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU GPLv3 License for more details.

## You should have received a copy of the GNU GPLv3 License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.


###############################################################################

## THIS IS THE SETUP FOR Bento antiX 32 bits built on antiX Core 23.2 i486

## How to use this Makefile
#  To install, type `make install` from within the root directory of the
#  bundle, with the administration rights.
#
#  To remove, type `make uninstall` also using administration rights. 
#  Before doing so, we advice you check carefully in the lower part of
# this file what is to be removed


SHELL := /bin/bash

# Base Destination Directory (for packaging support)
DESTDIR ?= /

# Specific /etc and its sub-directories
DEST_ETC = $(DESTDIR)/etc
DEST_ETC_LIGHTDM = $(DESTDIR)/etc/lightdm
DEST_ETC_LIGHTDM_CONF_D = $(DESTDIR)/etc/lightdm.conf.d
DEST_ETC_POLKIT_RULES_D = $(DESTDIR)/etc/polkit-1/rules.d
DEST_ETC_SKEL = $(DESTDIR)/etc/skel
DEST_ETC_SUDOERS_D = $(DESTDIR)/etc/sudoers.d
DEST_ETC_XDG_AUTOSTART = $(DESTDIR)/etc/xdg/autostart
DEST_ETC_XDG_MENUS = $(DESTDIR)/etc/xdg/menus
DEST_VAR_LIB = $(DESTDIR)/var/lib

# Specific sub-directories under /usr
DEST_USR_LOCAL_BIN = /usr/local/bin
DEST_USR_SHARE = /usr/share
DEST_USR_SHARE_ICONS = /usr/share/icons
DEST_USR_SHARE_THEMES = /usr/share/themes
DEST_USR_SHARE_BENTO = /usr/share/bento

# --- Source Paths (relative to project root './') ---

# Source directories
SRC_ETC = etc
SRC_LIGHTDM_CONF_D = etc/lighdm/lightdm.conf.d
SRC_ETC_SUDOERS_D = etc/sudoers.d/
SRC_ETCSKEL = etc/skel
SRC_ETC_XDG_AUTOSTART = etc/xdg/autostart
SRC_ETC_XDG_MENUS = etc/xdg/menus
SRC_BENTO = usr/share/bento
SRC_ICONS = usr/share/icons
SRC_POLKIT_RULES = etc/polkit-1/rules.d
SRC_THEMES = usr/share/themes


# Main targets
all:
	@echo "Type 'make install' to install Bento antiX components."
	@echo "Type 'make uninstall' to remove them."

install:
	echo "Installing Bento antiX components..."

	# Create specific destination directory required for installation
	# lightdm `data` directory was missing in antiX 23.2 core 32 sysvinit
	mkdir -p $(DEST_VAR_LIB)/lightdm/data


	# Copy individual files under /etc - if inittab already has `5` in
	# the line `id:5:initdefault:` then comment out the one below
	install -m 644 $(SRC_ETC)/environment $(DEST_ETC)/
	install -m 644 $(SRC_ETC)/inittab $(DEST_ETC)/

	# Copy LightDM config files and set permissions
	rsync -r $(SRC_LIGHTDM_CONF_D) $(DEST_ETC_LIGHTDM_CONF_D)/
	find $(DEST_ETC_LIGHTDM_CONF_D)/ -type f -exec chmod 644 {} \;

	# Copy Polkit rules files and set permissions
	rsync -r $(SRC_POLKIT_RULES) $(DEST_ETC_POLKIT_RULES_D)/
	find $(DEST_ETC_POLKIT_RULES_D)/ -type f -exec chmod 644 {} \;

	# Copy sudoers.d file and set permissions
	install -m 644 $(SRC_ETC_SUDOERS_D)/keep_qt_env $(DEST_ETC_SUDOERS_D)/

	# Copy XDG autostart files and set permissions
	rsync -r $(SRC_ETC_XDG_AUTOSTART) $(DEST_ETC_XDG_AUTOSTART)/
	find $(DEST_ETC_XDG_AUTOSTART)/ -type f -exec chmod 644 {} \;
	
	# To copy etc/xdg/autostart/welcome-information.desktop if needed:
	# use the preceeding rsync command with the "--exclude=welcome-information.desktop" 
	# option.

	# Copy XDG menus file and set permissions (single file, using install directly)
	install -m 644 $(SRC_ETC_XDG_MENUS)/bento-applications.menu $(DEST_ETC_XDG_MENUS)/
	ln -s $(DEST_ETC_XDG_MENUS)/bento-applications.menu $(DEST_ETC_XDG_MENUS)/applications.menu

	# Copy usr/local/bin scripts/binaries and set permissions
	rsync -r usr/local/bin/ $(DEST_USR_LOCAL_BIN)/
	find $(DEST_USR_LOCAL_BIN)/ -type f -exec chmod 755 {} \;
	# To copy usr/local/bin/welcome.sh if needed:
	# install -m 755 usr/local/bin/welcome.sh $(DEST_USR_LOCAL_BIN)/welcome.sh

	# Copy recursive directories using rsync
	rsync -rl $(SRC_ETCSKEL) $(DEST_ETC_SKEL)
	rsync -r $(SRC_BENTO) $(DEST_USR_SHARE_BENTO)
	rsync -rl $(SRC_ICONS) $(DEST_USR_SHARE_ICONS)
	rsync -rl $(SRC_THEMES) $(DEST_USR_SHARE_THEMES)

	# Reset file permissions for contents copied recursively
	find $(DEST_ETC_SKEL) -type f -exec chmod 644 {} \;
	find $(DEST_ETC_SKEL) -type d -exec chmod 755 {} \;
	chmod +x $(DEST_ETC_SKEL)/.config/openbox/scripts/oblocale.sh
	chmod +x $(DEST_ETC_SKEL)/.config/openbox/lang/autostart-*
	
	find $(DEST_USR_SHARE_BENTO) -type f -exec chmod 644 {} \;
	find $(DEST_USR_SHARE_BENTO) -type d -exec chmod 755 {} \;

	find $(DEST_USR_SHARE_ICONS) -type f -exec chmod 644 {} \;
	find $(DEST_USR_SHARE_ICONS) -type d -exec chmod 755 {} \;

	find $(DEST_USR_SHARE_THEMES) -type f -exec chmod 644 {} \;
	find $(DEST_USR_SHARE_THEMES) -type d -exec chmod 755 {} \;

	# Setup LightDM data directory rights and permissions
	chown lightdm:lightdm $(DEST_VAR_LIB)/lightdm/data
	chmod 750 $(DEST_VAR_LIB)/lightdm/data

	# Update desktop database
	update-desktop-database $(DEST_ETC_XDG_AUTOSTART)
	update-desktop-database $(DEST_USR_SHARE_BENTO)/applications


uninstall:
	echo "Removing Bento antiX components..."

	# DO NOT ! Remove `/etc/environment` or `/etc/inittab` !
	
	# Remove these two only if needed
	# rm -f $(DEST_ETC_LIGHTDM_CONF_D)/01_debian.conf
	# rm -f $(DEST_ETC_LIGHTDM_CONF_D)/0_bento.conf
	rm -f $(DEST_ETC_LIGHTDM_CONF_D)/lightdm.conf
	rm -f $(DEST_ETC_LIGHTDM_CONF_D)/lightdm-gtk-greeter.conf

	## Either one file at a time or as a batch : choose!
	# 	rm -f $(DEST_ETC_POLKIT_RULES_D)/20-Udisks2-filesystem-mount.rules
	# 	rm -f $(DEST_ETC_POLKIT_RULES_D)/30-policykit-pkexec-auth.rules
	# 	rm -f $(DEST_ETC_POLKIT_RULES_D)/40-gparted-sudo-auth.rules
	# 	rm -f $(DEST_ETC_POLKIT_RULES_D)/50-lightdm-gtk-greeter-settings.rules
	# 	rm -f $(DEST_ETC_POLKIT_RULES_D)/60-synaptic-sudo-rules
	# 	rm -f $(DEST_ETC_POLKIT_RULES_D)/70-power-management-sudo-users.rules
	rm -f  $(DEST_ETC_POLKIT_RULES_D)/*.rules

	# We might want to keep it, can't hurt
	# rm -f $(DEST_ETC_SUDOERS_D)/keep_qt_env

	rm -f $(DEST_ETC_XDG_AUTOSTART)/connman-gtk.desktop
	rm -f $(DEST_ETC_XDG_AUTOSTART)/cp-minstall-launcher.desktop
	rm -f $(DEST_ETC_XDG_AUTOSTART)/fix-network-live.desktop
	rm -f $(DEST_ETC_XDG_AUTOSTART)/welcome-information.desktop

	## Restore your applications.menu afterwards
	rm -f $(DEST_ETC_XDG_MENUS)/bento-applications.menu
	
	## check any script you would want to keep
	rm -f $(DEST_USR_LOCAL_BIN)/bento-antix.desktop.sh
	rm -f $(DEST_USR_LOCAL_BIN)/fix-network-live.sh
	rm -f $(DEST_USR_LOCAL_BIN)/openbox-menu
	rm -f $(DEST_USR_LOCAL_BIN)/xcompmgr.sh
	rm -f $(DEST_USR_LOCAL_BIN)/xsnow.sh
	rm -f $(DEST_USR_LOCAL_BIN)/welcome.sh

	# Remove directories recursively
	rm -rf $(DEST_USR_SHARE_BENTO)
	
	# The `Vibrantly-Simple-Dark-Pink` and `Vibrantly-Simple-Dark-Teal` icon sets
	rm -rf $(DEST_USR_SHARE_ICONS)/{Vibrantly*}
	
	# Openbox additional themes were in `/usr/share/themes`
	rm -rf $(DEST_USR_SHARE_THEMES)/{Imagine*}

	# Folders and files from the etcskel directory were in `/etc/skel`
	rm -rf $(DEST_ETC_SKEL)/{.config,.local,.bash_logout,.bashrc,.gtkrc-2.0,.jgmenurc,.profile,.vimrc,.Xdefaults,.xinitrc,.Xresources,.xsession}

	# Do NOT remove /var/lib/lightdm/data as it's managed by the system's LightDM package.
