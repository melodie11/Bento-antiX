#!/bin/bash

# This script copies the Bento antiX installer launcher to the desktop

# let's be sure a Desktop is indeed created before the script starts
xdg-user-dirs-update

# shellcheck disable=SC1091
source "${HOME}"/.config/user-dirs.dirs

if [[ -z "${XDG_DESKTOP_DIR}" ]]; then
    echo "Empty XDG_DESKTOP_DIR variable"
    exit
fi

if [[ ! -d "${XDG_DESKTOP_DIR}" ]]; then
    echo "The location of the desktop does not exist"
    exit
fi

# Are we in a live session? We want this to happen only in this case
# This works in antiX respins. Else, it will need to be adapted.
if	[ -d "/live" ]; then
	cp -f "/usr/share/applications/minstall.desktop" "$XDG_DESKTOP_DIR"
	cp -n "/rofs/usr/share/applications/minstall.desktop" "$XDG_DESKTOP_DIR"
fi

