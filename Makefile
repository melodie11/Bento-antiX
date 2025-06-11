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
#  To remove, type `make clean` also using administration rights.

SHELL := /bin/bash

## Destination Directories
ETC_LIGHTDM = /etc/lightdm
ETC_POLKIT_PKLA = /etc/polkit-1/localauthority/50-local.d #Corrected the final sub-directory name - 50-local.d instead of 50-rules.d
ETC_POLKIT_RULES = /etc/polkit-1/rules.d
ETC_SKEL = /etc/skel
ETC_XDG_AUTOSTART = /etc/xdg/autostart
ETC_XDG_MENUS = /etc/xdg/menus
USR_LOCAL_BIN = /usr/local/bin
USR_SHARE = /usr/share
USR_SHARE_THEMES = /usr/share/themes
USR_SHARE_ICONS = /usr/share/icons

## Source Files and Directories
AUTOSTART = autostart
BENTO = bento
CONFIGS = configs
ETCSKEL = etcskel
ICONS = icons
PKRULES = configs/polkit-1/rules.d  #Added `polkit-1` in the path previously forgotten
SRC = src
THEMES = themes

# ---
# Variables for CLEAN target: listing actual files/directories installed.
# These lists are based on your project's tree and install rules.
# No changes to your initial variable definitions.
# ---

# Files installed into $(ETC_XDG_AUTOSTART) from $(AUTOSTART)/*
AUTOSTART_FILES_TO_CLEAN = \
	connman-gtk.desktop \
	cp-minstall-launcher.desktop \
	fix-network-live.desktop \
	welcome-information.desktop

# Directory installed under $(USR_SHARE)
USR_SHARE_DIRS_TO_CLEAN = $(BENTO)

# File installed into $(ETC_XDG_MENUS) from $(CONFIGS)/applications.menu
XDG_MENUS_FILES_TO_CLEAN = applications.menu

# File installed into /etc from $(CONFIGS)/environment
ETC_FILES_TO_CLEAN = environment # This file goes directly into /etc, not a sub-directory

# Files installed into $(ETC_LIGHTDM)/lightdm.conf.d/ from $(CONFIGS)/lightdm/*
LIGHTDM_FILES_TO_CLEAN = \
	01_debian.conf \
	0_bento.conf \
	lightdm.conf \
	lightdm-gtk-greeter.conf

# Files installed into $(ETC_POLKIT_RULES)/ from $(PKRULES)/*
# Note: PKRULES = configs/rules.d. Your install rule used $(CONFIGS)/polkit-1/rules.d/*
# Corrected here to use the full path from the tree, as PKRULES is not the full path.
POLKIT_RULES_FILES_TO_CLEAN = \
	01-antix-privileges.rules \
	02-bento-desktop-session.rules \
	03-polkit-user-session.rules

# Files installed into /etc/polkit-1/localauthority/50-local.d/ from $(CONFIGS)/polkit-1/(55-conf.pkla, 55-consolekit-conf.pkla)
# Your ETC_POLKIT_PKLA points to /etc/polkit-1/localauthority/50-rules.d, but install goes to 50-local.d.
# The clean rule will target the actual install location.
POLKIT_PKLA_FILES_TO_CLEAN = \
	55-conf.pkla \
	55-consolekit-conf.pkla

# Files and directories from $(ETCSKEL)/ copied to $(ETC_SKEL)/
ETCSKEL_CONTENTS_TO_CLEAN = $(notdir $(wildcard $(ETCSKEL)/* $(ETCSKEL)/.*))

# Scripts and binary installed into $(USR_LOCAL_BIN)/ from $(SRC)/*
USR_LOCAL_BIN_FILES_TO_CLEAN = \
	bento-antix.desktop.sh \
	fix-network-live.sh \
	openbox-menu \
	welcome.sh \
	xcompmgr.sh \
	xsnow.sh

# Directories installed under $(USR_SHARE_THEMES)/ from $(THEMES)/
USR_SHARE_THEMES_DIRS_TO_CLEAN = \
	"Imagine Ambiance" \
	"Imagine Clearlooks" \
	"Imagine CurvedDark" \
	"Imagine CurvedLight" \
	"Imagine Eight" \
	"Imagine FlatCarbon" \
	"Imagine FlatSuperwhite" \
	"Imagine Human" \
	"Imagine Radiance" \
	"Imagine Seven"

# Files and directories installed under $(USR_SHARE_ICONS)/ from $(ICONS)/
USR_SHARE_ICONS_TO_CLEAN = \
	keyboard.png \
	run.png \
	run.svg \
	Vibrantly-Simple-Dark-Pink \
	Vibrantly-Simple-Dark-Teal

## INSTALL
install:
# Autostart files from autostart directory go to `/etc/xdg/autostart`
	install -m 644 $(AUTOSTART)/* $(ETC_XDG_AUTOSTART)

# The `bento` directory with all sub-directories and images go to `/usr/share/bento`
	rsync -rl $(BENTO) $(USR_SHARE)/
	find $(USR_SHARE)/$(BENTO)/ -type f -exec chmod 644 {} \;
	find $(USR_SHARE)/$(BENTO)/ -type d -exec chmod 755 {} \;

## configs
# The file used to manage *the categories* for *the applications menus* go into
# `/etc/xdg/menus`
	install -m 644 $(CONFIGS)/applications.menu $(ETC_XDG_MENUS)
	
# The `configs/environment` file goes into `/etc`
	install -m 644 $(CONFIGS)/environment /etc/

# The `configs/lightdm` files go into /etc/lightdm.conf.d
	install -D -m 644 $(CONFIGS)/lightdm/* $(ETC_LIGHTDM)/lightdm.conf.d/

# Newer configuration Polkit-1 style goes into `/etc/polkit-1/rules.d`
#   install -m 644 $(CONFIGS)/polkit-1/rules.d/* $(ETC_POLKIT_RULES)/ or: 
	install -m 644 $(PKRULES)/* $(ETC_POLKIT_RULES)
	
	install -D -m 644 \
			$(CONFIGS)/polkit-1/55-conf.pkla \
			$(CONFIGS)/polkit-1/55-consolekit-conf.pkla \
			$(ETC_POLKIT)/localauthority/50-local.d/
	chmod 700 $(ETC_POLKIT)/localauthority  # DO NOT Apply chmod to the sub-directory

# Folders and files from the etcskel directory go to `/etc/skel`
	rsync -r -l $(ETCSKEL)/ $(ETC_SKEL)
	
# After rsync fix permissions in `/etc/skel` sub-directories
	find $(ETCSKEL) -type d -exec chmod 755 {} \;
	
# After rsync We need the oblocale.sh script located in the `scripts` directory to be executable
	chmod a+x $(ETC_SKEL)/.config/openbox/scripts/oblocale.sh
	
# After rsync we need the language autostart-* files to be executable
	chmod a+x $(ETC_SKEL)/.config/openbox/lang/autostart-*

## Scripts for `/usr/local/bin`
# The `*.sh` scripts and openbox-menu binary (temporary until openbox-menu be
# packaged again) will go into `/usr/local/bin`
	rsync -r $(SRC)/ $(USR_LOCAL_BIN)/
	chmod -R 755 $(USR_LOCAL_BIN)/
	
# Openbox additional themes go into `/usr/share/themes` (and fix permissions)
	rsync -rl $(THEMES)/ $(USR_SHARE_THEMES)/
	find $(USR_SHARE_THEMES)/ -type f -exec chmod 644 {} \;
	find $(USR_SHARE_THEMES)/ -type d -exec chmod 755 {} \;

# `Vibrantly-Simple-Dark-Pink` and `Vibrantly-Simple-Dark-Teal` icon sets and
# `run.svg`, `run.png` and `keyboard.png` go into `/usr/share/icons`
	rsync -rl $(ICONS)/ $(USR_SHARE_ICONS)/
	find $(USR_SHARE_ICONS)/ -type f -exec chmod 644 {} \;
	find $(USR_SHARE_ICONS)/ -type d -exec chmod 755 {} \;

## CONFIGURATION FOR YOUR $HOME
## If you are in an already installed system uncomment next line. (Ackownledge the
## `-l` switch. It copies the symlinks to the destination).
# rsync -r -l -v --progress $(ETCSKEL) ~/.config/

## first openbox-menu start uncomment too if in an installed system
# openbox-menu > ~/.cache/menu.xml

## CLEAN
.PHONY: clean

clean:
	@echo "--- Cleaning up Bento antiX 32-bit components ---"
	# Remove autostart files
	rm -f $(addprefix $(ETC_XDG_AUTOSTART)/,$(AUTOSTART_FILES_TO_CLEAN))

	# Remove bento directory
	rm -rf $(addprefix $(USR_SHARE)/,$(USR_SHARE_DIRS_TO_CLEAN))

	# Remove menu configuration file
	rm -f $(addprefix $(ETC_XDG_MENUS)/,$(XDG_MENUS_FILES_TO_CLEAN))

	# Remove environment file from /etc (direct path, as no variable was used in install)
	rm -f /etc/$(ETC_FILES_TO_CLEAN)

	# Remove lightdm configuration files
	rm -f $(addprefix $(ETC_LIGHTDM)/lightdm.conf.d/,$(LIGHTDM_FILES_TO_CLEAN))

	# Remove polkit rules files
	rm -f $(addprefix $(ETC_POLKIT_RULES)/,$(POLKIT_RULES_FILES_TO_CLEAN))

	# Remove polkit .pkla files (using the explicit install path as your variable points elsewhere)
	rm -f $(addprefix /etc/polkit-1/localauthority/50-local.d/,$(POLKIT_PKLA_FILES_TO_CLEAN))

	# Remove files and directories copied to /etc/skel
	# This targets top-level items from $(ETCSKEL) that were copied to $(ETC_SKEL).
	# Use caution if /etc/skel contains other important system files not managed by this Makefile.
	rm -rf $(addprefix $(ETC_SKEL)/,$(ETCSKEL_CONTENTS_TO_CLEAN))

	# Remove scripts and binaries from /usr/local/bin
	rm -f $(addprefix $(USR_LOCAL_BIN)/,$(USR_LOCAL_BIN_FILES_TO_CLEAN))

	# Remove themes
	rm -rf $(addprefix $(USR_SHARE_THEMES)/,$(USR_SHARE_THEMES_DIRS_TO_CLEAN))

	# Remove icons
	rm -rf $(addprefix $(USR_SHARE_ICONS)/,$(USR_SHARE_ICONS_TO_CLEAN))
	@echo "--- Cleanup complete! ---"
