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
#  this file what is to be removed

#  If installing in a running system, use `rsync -rl /etc/skel /home/you` after
#  the `make install` part. Also the `make clean` does not remove all that was
#  installed. It is up to you to check what more should be removed.

SHELL := /bin/bash

## Source Files and Directories (relative to the project root)
# etc/
ETC_SRC=etc
ETC_DEFAULT_SRC=etc/default/grub
ETC_SKEL_SRC=etc/skel
ETC_LIGHTDM_CONF_D_SRC=etc/lightdm/lightdm.conf.d
ETC_POLKIT_RULES_D_SRC=etc/polkit-1/rules.d
ETC_SUDOERS_D_SRC=etc/sudoers.d
ETC_XDG_AUTOSTART_SRC=etc/xdg/autostart
ETC_XDG_MENUS_SRC=etc/xdg/menus

# usr/
USR_LOCAL_BIN_SRC=usr/local/bin
USR_SHARE_BENTO_SRC=usr/share/bento
USR_SHARE_ICONS_SRC=usr/share/icons
USR_SHARE_THEMES_SRC=usr/share/themes


## Destination Directories (absolute paths on the system)
ETC=/etc
ETC_DEFAULT=/etc/default/
ETC_XDG_MENUS=/etc/xdg/menus
ETC_LIGHTDM_CONF_D=/etc/lightdm/lightdm.conf.d
ETC_POLKIT_RULES_D=/etc/polkit-1/rules.d
ETC_SKEL=/etc/skel
USR_LOCAL_BIN=/usr/local/bin
USR_SHARE=/usr/share
USR_SHARE_BENTO=/usr/share/bento
USR_SHARE_ICONS=/usr/share/icons
USR_SHARE_THEMES=/usr/share/themes

## INSTALL
install:
	@echo "Installing Bento antiX components..."

# /etc/environment and /etc/inittab
	install -m 644 "$(ETC_SRC)"/environment "$(ETC)"/
	install -m 644 "$(ETC_SRC)"/inittab "$(ETC)"/

# Grub without background
	install -m 644 "$ETC_DEFAULT_SRC" "$ETC_DEFAULT"

	@echo "Updating Grub"
	update-grub2
	
# Folders and files from etc/skel go to /etc/skel
# Use rsync -r because symlinks will be created explicitly afterwards.
	rsync -r "$(ETC_SKEL_SRC)"/ "$(ETC_SKEL)"/

# Create symlinks for Openbox config files in /etc/skel/.config/openbox
	ln -s "$(ETC_SKEL)"/.config/openbox/lang/autostart-en "$(ETC_SKEL)"/.config/openbox/autostart
	ln -s "$(ETC_SKEL)"/.config/openbox/lang/menu.xml-en "$(ETC_SKEL)"/.config/openbox/menu.xml
	ln -s "$(ETC_SKEL)"/.config/openbox/lang/rc.xml-en "$(ETC_SKEL)"/.config/openbox/rc.xml

# Set executable permission for oblocale.sh
	chmod a+x "$(ETC_SKEL)"/.config/openbox/scripts/oblocale.sh

# XDG menus file (etc/xdg/menus/bento-applications.menu)
	install -m 644 "$(ETC_XDG_MENUS_SRC)"/bento-applications.menu "$(ETC_XDG_MENUS)"/
	# Also create the applications.menu symlink - This symlink will now be created here, not copied by rsync -l
	ln -s "$(ETC_XDG_MENUS)"/bento-applications.menu "$(ETC_XDG_MENUS)"/applications.menu

# LightDM configuration files
	mkdir -p "$(ETC_LIGHTDM_CONF_D)"
	install -m 644 "$(ETC_LIGHTDM_CONF_D_SRC)"/{01_debian.conf,0_bento.conf,lightdm.conf,lightdm-gtk-greeter.conf} "$(ETC_LIGHTDM_CONF_D)"/

# Polkit rules files
	# Use rsync -r as no symlinks are expected in rules files themselves, only recursive copy.
	rsync -r "$(ETC_POLKIT_RULES_D_SRC)"/ "$(ETC_POLKIT_RULES_D)"/
	find "$(ETC_POLKIT_RULES_D)"/ -type f -exec chmod 644 {} \; # Set permissions for rule files

# XDG autostart files
	# Use rsync -r as no symlinks are expected in autostart files themselves.
	rsync -r "$(ETC_XDG_AUTOSTART_SRC)"/ "$(ETC)"/xdg/autostart/
	find "$(ETC)"/xdg/autostart/ -type f -exec chmod 644 {} \; # Set permissions for files

# Scripts for /usr/local/bin
	# Use rsync -r as no symlinks are expected in scripts themselves.
	rsync -r "$(USR_LOCAL_BIN_SRC)"/ "$(USR_LOCAL_BIN)"/
	find "$(USR_LOCAL_BIN)"/ -type f -exec chmod 755 {} \; # Ensures scripts are executable

# Bento theme files for /usr/share/bento
	# Use rsync -r as no symlinks are expected here.
	rsync -r "$(USR_SHARE_BENTO_SRC)"/ "$(USR_SHARE_BENTO)"/
	find "$(USR_SHARE_BENTO)"/ -type f -exec chmod 644 {} \;
	find "$(USR_SHARE_BENTO)"/ -type d -exec chmod 755 {} \; # Ensure directories are traversable

# Openbox additional themes for /usr/share/themes
	# Use rsync -rl as per your instruction (safer if they internally use symlinks).
	rsync -rl "$(USR_SHARE_THEMES_SRC)"/ "$(USR_SHARE_THEMES)"/
	find "$(USR_SHARE_THEMES)"/ -type f -exec chmod 644 {} \;
	find "$(USR_SHARE_THEMES)"/ -type d -exec chmod 755 {} \;

# Icon sets for /usr/share/icons
	# Use rsync -rl as per your instruction (safer if they internally use symlinks).
	rsync -rl "$(USR_SHARE_ICONS_SRC)"/ "$(USR_SHARE_ICONS)"/
	find "$(USR_SHARE_ICONS)"/ -type f -exec chmod 644 {} \;
	find "$(USR_SHARE_ICONS)"/ -type d -exec chmod 755 {} \;

## UNINSTALL
clean:
	@echo "Starting uninstallation…"


# Remove files/folders copied to /etc/skel by your project (selective removal)
	rm -rf "$(ETC_SKEL)"/.bash_logout
	rm -rf "$(ETC_SKEL)"/.jgmenurc
	rm -rf "$(ETC_SKEL)"/.vimrc
	rm -rf "$(ETC_SKEL)"/.Xdefaults
	rm -rf "$(ETC_SKEL)"/.xinitrc
	rm -rf "$(ETC_SKEL)"/.Xresources
	rm -rf "$(ETC_SKEL)"/.xsession
	rm -rf "$(ETC_SKEL)"/.config/openbox

# Remove XDG menus files and symlink (bento-applications.menu and its symlink)
	rm -f "$(ETC_XDG_MENUS)"/bento-applications.menu
	rm -f "$(ETC_XDG_MENUS)"/applications.menu # The symlink

# Remove LightDM configuration files
	rm -f "$(ETC_LIGHTDM_CONF_D)"/{01_debian.conf,0_bento.conf,lightdm.conf,lightdm-gtk-greeter.conf}

# Polkit rules files
	rm -f "$(ETC_POLKIT_RULES_D)"/{20-Udisks2-filesystem-mount.rules,30-policykit-pkexec-auth.rules,40-gparted-sudo-auth.rules,50-lightdm-gtk-greeter-settings.rules,60-synaptic-sudo-auth.rules,70-power-management-sudo-users.rules}

# Remove XDG autostart files
	rm -f "$(ETC)"/xdg/autostart/{connman-gtk.desktop,cp-minstall-launcher.desktop,fix-network-live.desktop,welcome-information.desktop}

# Remove scripts from /usr/local/bin
	rm -f "$(USR_LOCAL_BIN)"/{bento-antix.desktop.sh,fix-network-live.sh,openbox-menu,welcome.sh,xcompmgr.sh,xsnow.sh}

# Remove /usr/share/bento directory
	rm -rf "$(USR_SHARE_BENTO)"

# Remove Openbox additional themes
	rm -rf "$(USR_SHARE_THEMES)"/'Imagine Ambiance'
	rm -rf "$(USR_SHARE_THEMES)"/'Imagine Clearlooks'
	rm -rf "$(USR_SHARE_THEMES)"/'Imagine CurvedDark'
	rm -rf "$(USR_SHARE_THEMES)"/'Imagine CurvedLight'
	rm -rf "$(USR_SHARE_THEMES)"/'Imagine Eight'
	rm -rf "$(USR_SHARE_THEMES)"/'Imagine FlatCarbon'
	rm -rf "$(USR_SHARE_THEMES)"/'Imagine FlatSuperwhite'
	rm -rf "$(USR_SHARE_THEMES)"/'Imagine Human'
	rm -rf "$(USR_SHARE_THEMES)"/'Imagine Radiance'
	rm -rf "$(USR_SHARE_THEMES)"/'Imagine Seven'

# Remove icon sets
	rm -f "$(USR_SHARE_ICONS)"/keyboard.png
	rm -f "$(USR_SHARE_ICONS)"/run.png
	rm -f "$(USR_SHARE_ICONS)"/run.svg
	rm -rf "$(USR_SHARE_ICONS)"/Vibrantly-Simple-Dark-Pink
	rm -rf "$(USR_SHARE_ICONS)"/Vibrantly-Simple-Dark-Teal
