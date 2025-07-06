#!/bin/bash

# This script installs various application groups which in turn pull in their
# dependencies. It allows starting from an antiX Core edition to a distribution
# working in graphical mode. (Here, with Openbox and the Bento setup).
# It requires root privileges to run.

# Exit immediately if a command exits with a non-zero status.
set -euo pipefail
set -x

# Initial system update and cleanup
echo "Performing initial system update and cleanup..."
apt update
apt purge -y --autoremove elinks irssi libpam-elogind
apt full-upgrade -y # Corrected from dist-upgrade to full-upgrade
echo "Initial system update and cleanup complete."

# --- Xorg server ---
echo "Installing Xorg server and its dependencies..."
apt install -y --install-recommends \
	mesa-utils \
	xbitmaps \
	xfonts-100dpi \
	xfonts-scalable \
	xinput \
	xinit \
	xorg \
	xserver-xorg
echo "Xorg server group installed successfully."

# --- Sub-system ---
echo "Installing Sub-system components and their dependencies..."
apt install -y --install-recommends \
	accountsservice \
	consolekit \
	dbus-x11 \
	gpg-agent \
	gvfs \
	gvfs-backends \
	gvfs-bin \
	gvfs-fuse \
	iso-codes \
	libbluray2 \
	libatk-adaptor \
	libpam-ck-connector \
	pm-utils \
	policykit-1 \
	policykit-1-gnome \
	polkitd-pkla \
	udev \
	udisks2 \
	upower
echo "Sub-system group installed successfully."

# --- Graphical session ---
echo "Installing Graphical session components and their dependencies..."
apt install -y --install-recommends \
	lightdm \
	lightdm-autologin-greeter \
	lightdm-gtk-greeter \
	lightdm-gtk-greeter-settings \
	lightdm-settings
echo "Graphical session group installed successfully."

# --- Needed in antiX ---
echo "Installing antiX specific packages and their dependencies..."    "====> Le3fpad n'était pas installé"
apt install -y --install-recommends \
	iso-snapshot \
	iso-snapshot-cli \
	isolinux \
	le3fpad \
	linux-libc-dev
echo "antiX specific packages group installed successfully."

# --- Bento main ---
echo "Installing Bento main packages and their dependencies..."
apt install -y --install-recommends \
	libmenu-cache3 \
	openbox \
	obsession
echo "Bento main group installed successfully."

# --- To compile openbox-menu (can be removed later) ---
echo "Installing packages for compiling openbox-menu and their dependencies..."
apt install -y --install-recommends \
	build-essential \
	dkms \
	libgtk-3-dev \
	libmenu-cache-dev
echo "openbox-menu compilation packages group installed successfully."

# --- Drivers ---
echo "Installing Drivers and their dependencies..."
apt install -y --install-recommends \
	va-driver-all
echo "Drivers group installed successfully."

# --- Bento additions ---
echo "Installing Bento additions and their dependencies..."
apt install -y --install-recommends \
	arandr \
	feh \
	geany \
	hsetroot \
	libfm-tools \
	libfm4 \
	lxpanel \
	pcmanfm \
	sakura \
	tint2 \
	xcompmgr \
	yad
echo "Bento additions group installed successfully."

# --- System tools - text and GUI ---
echo "Installing System tools (text and GUI) and their dependencies..."
apt install -y --install-recommends \
	apt-file \
	curl \
	gksu \
	gnome-system-tools \
	isomaster \
	mc \
	pinentry-gtk2 \
	software-properties-gtk \
	synaptic \
	vim \
	wget
echo "System tools group installed successfully."

# --- User preferences ---
echo "Installing User preferences packages and their dependencies..."
apt install -y --install-recommends \
	lxappearance \
	qt5ct
echo "User preferences group installed successfully."

# --- Audio ---
echo "Installing Audio packages and their dependencies..."
apt install -y --install-recommends \
	pavucontrol \
	volumeicon-alsa
echo "Audio group installed successfully."

# --- Base tools ---
echo "Installing Base tools and their dependencies..."
apt install -y --install-recommends \
	file-roller \
	p7zip \
	p7zip-full \
	unzip \
	zip
echo "Base tools group installed successfully."

# --- Printing ---
echo "Installing Printing packages and their dependencies..."
apt install -y --install-recommends \
	bluez-cups
echo "Printing group installed successfully."

# --- Networking ---
echo "Installing Networking packages and their dependencies..."
apt install -y --install-recommends \
	bind9 \
	bluez \
	bluez-firmware \
	broadcom-sta-dkms \
	connman \
	connman-gtk \
	connman-ui \
	dnsutils \
	modemmanager \
	net-tools \
	openresolv \
	openssh-client \
	openssh-server \
	ppp \
	pppconfig \
	ppppoe \
	sshfs \
	usb-modeswitch \
	wpasupplicant
echo "Networking group installed successfully."

# --- Themes ---
echo "Installing Themes and their dependencies..."
apt install -y --install-recommends \
	adwaita-icon-theme \
	clearlooks-phenix-theme \
	gnome-accessibility-theme \
	gnome-icon-theme \
	gnome-themes-extra \
	gnome-themes-extra-data \
	papirus-icon-theme \
	gtk2-engines
echo "Themes group installed successfully."

# --- fonts ---
echo "Installing fonts and their dependencies..."
apt install -y --install-recommends \
	fontconfig \
	fonts-crosextra-carlito \
	fonts-droid-fallback \
	fonts-noto-mono \
	ttf-bitstream-vera \
	xfonts-terminus
echo "fonts group installed successfully."

# --- Test and run ISOs in Virtualbox ---
echo "Installing Virtualbox ISO testing tools and their dependencies..."
apt install -y --install-recommends \
	virtualbox-guest-dkms \
	virtualbox-guest-utils \
	virtualbox-guest-x11
echo "Virtualbox ISO testing tools group installed successfully."

echo "All specified packages have been processed."

