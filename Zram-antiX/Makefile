############################ INFORMATION ######################################

## THIS IS THE SETUP FOR Zram antiX in the Bento antiX builds. It is used 
## with Bento Openbox environements and can be ported to other setups.

## The Bento Openbox setup is available in the Bento-Openbox repository 
## at Github.com . :)

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

## How to use this Makefile
#  To install, type `make install` from within the root directory of the bundle,
#  with the administration rights.
#  To remove, type `make uninstall` also using administration rights.

SHELL := /bin/bash
# Source files sitting in the current directory.
SRC_DEFAULT_CONF = etc/default/zram
SRC_INIT_SCRIPT = etc/init.d/zram
SRC_GUI_SCRIPT = usr/local/bin/toggle-zram-gui.sh
SRC_DESKTOP_FILE = usr/share/applications/zram-control.desktop
SRC_POST_INSTALL = post-install
SRC_POST_REMOVAL = post-removal

# Destination base directory (can be overridden for packaging, e.g., DESTDIR=/tmp/staging)
DESTDIR ?= /

# Destination directories (files will be placed within these)
DEST_DEFAULT_DIR = $(DESTDIR)etc/default
DEST_INIT_DIR = $(DESTDIR)etc/init.d
DEST_GUI_DIR = $(DESTDIR)usr/local/bin
DEST_DESKTOP_DIR = $(DESTDIR)usr/share/applications


# Main targets
all:
	@# Type 'make install' to install ZRAM control scripts and configuration.
	@# Type 'make uninstall' to remove them.

## Installation target
install:
# Installation of ZRAM components complete.
# Copying files and setting permissions...

# The default zram configuration file goes into /etc/default
	install -m 644 $(SRC_DEFAULT_CONF) $(DEST_DEFAULT_DIR)

# The zram init script goes into /etc/init.d
	install -m 755 $(SRC_INIT_SCRIPT) $(DEST_INIT_DIR)

# The toggle-zram-gui.sh GUI script goes into /usr/local/bin
	install -m 755 $(SRC_GUI_SCRIPT) $(DEST_GUI_DIR)

# The zram-control.desktop desktop file goes into /usr/share/applications
	install -m 644 $(SRC_DESKTOP_FILE) $(DEST_DESKTOP_DIR)

# Starting ZRAM service...
# Ensure the post-install script is executable before running it
	chmod +x $(SRC_POST_INSTALL)
# Execute the post-install script, passing DESTDIR as an argument for packaging awareness
# This script is responsible for managing update-rc.d or similar system configurations.
	./$(SRC_POST_INSTALL) $(DESTDIR)

# Uninstallation target
uninstall:
# Ensure the post-removal script is executable before running it
	chmod +x $(SRC_POST_REMOVAL)
# Execute the post-removal script, passing DESTDIR as an argument for packaging awareness
	./$(SRC_POST_REMOVAL) $(DESTDIR)

# Removing installed files...
	rm -f $(DEST_DEFAULT_FILE)
	rm -f $(DEST_INIT_FILE)
	rm -f $(DEST_GUI_FILE)
	rm -f $(DEST_DESKTOP_FILE)

