#!/bin/bash

# This script copies the Bento antiX installer launcher to the desktop

# let's be sure a Desktop is indeed created before the script starts
xdg-user-dirs-update

# shellcheck disable=SC1091
source "${HOME}"/.config/user-dirs.dirs

if [[ -z "${XDG_DESKTOP_DIR}" ]]; then
    echo "Empty XDG_DESKTOP_DIR variable" >&2 # Rediriger vers stderr
    exit 1 # Utiliser un code de sortie non-zéro pour erreur
fi

if [[ ! -d "${XDG_DESKTOP_DIR}" ]]; then
    echo "The location of the desktop does not exist: ${XDG_DESKTOP_DIR}" >&2 # Rediriger vers stderr
    exit 1 # Utiliser un code de sortie non-zéro pour erreur
fi

# Are we in a live session? We want this to happen only in this case
# This works in antiX respins - has to be checked elsewhere
if [ -d "/live" ]; then
    PRIMARY_SOURCE="/usr/share/applications/minstall.desktop"
    SKEL_FALLBACK_SOURCE="/etc/skel/.local/share/applications/minstall.desktop"
    DEST_PATH="${XDG_DESKTOP_DIR}/minstall.desktop" # Utiliser un chemin complet pour la destination

    # --- Logic: Check primary source first, then fallback ---

    if [ -f "$PRIMARY_SOURCE" ]; then
        # If minstall.desktop exists in the primary location, copy it.
        if ! install -m 755 "$PRIMARY_SOURCE" "$DEST_PATH"; then
            echo "Error: Failed to copy minstall.desktop from $PRIMARY_SOURCE to Desktop." >&2
            # Not exiting here, allow script to continue if other tasks follow
        fi
    elif [ -f "$SKEL_FALLBACK_SOURCE" ]; then
        # If primary source does NOT exist, but fallback source DOES exist, copy from fallback.
        if ! install -m 755 "$SKEL_FALLBACK_SOURCE" "$DEST_PATH"; then
            echo "Error: Failed to copy minstall.desktop from $SKEL_FALLBACK_SOURCE to Desktop." >&2
            # Not exiting here, allow script to continue if other tasks follow
        fi
    else
        # If neither source file exists, issue a warning.
        echo "Warning: minstall.desktop not found at $PRIMARY_SOURCE nor at $SKEL_FALLBACK_SOURCE. Desktop icon will not be created." >&2
    fi
else
    # Not in a live session, so exit cleanly as per original script logic.
    exit 0
fi

# You can add more tasks here that depend on the minstall.desktop being copied,
# or simply let the script finish.

exit 0 # Exit cleanly after executing the logic
