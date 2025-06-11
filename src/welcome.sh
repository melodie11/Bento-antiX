#!/bin/bash
#
# Script to create an info file on the Live desktop.
#

# Define the content of the info file
MESSAGE_CONTENT="Welcome to Bento antiX 32bits!
The default password for the administrator root is \"root\"
The default password for the user is \"demo\"

The installer needs the root password. Other administration tools usually need
only the default user password.

You will be invited to create your own during installation.
Enjoy!

Bienvenue sur Bento antiX 32bits !
Le mot de passe par défaut pour l'administrateur root est \"root\"
Le mot de passe par défaut pour l'utilisateur est \"demo\"

L'installeur nécessite le mot de passe root. D'autres outils d'administration
ont généralement besoin du mot de passe de l'utilisateur par défaut.

Vous serez invité à créer les vôtres durant l'installation.
Profitez-en !"

# Define the output file name
OUTPUT_FILENAME="INSTALLATION.TXT"

# Are we in a live session? We want this to happen only in this case
# This works in antiX respins - has to be checked elsewhere
if [ ! -d "/live" ]; then
    # Not in Live mode, exit the script.
    exit 0
fi

# Let's be sure a Desktop is indeed created before the script starts
# This command updates the XDG user directories configuration
xdg-user-dirs-update

# shellcheck disable=SC1091
# Source the user-dirs.dirs file to get XDG_DESKTOP_DIR
if [[ -f "${HOME}/.config/user-dirs.dirs" ]]; then
    source "${HOME}"/.config/user-dirs.dirs
else
    # Fallback if user-dirs.dirs does not exist (unlikely in a graphical session)
    XDG_DESKTOP_DIR="${HOME}/Desktop"
fi


# Check if XDG_DESKTOP_DIR variable is empty
if [[ -z "${XDG_DESKTOP_DIR}" ]]; then
    # If the variable is empty, we cannot determine the Desktop path, so exit.
    exit 1
fi

# Check if the determined Desktop directory exists
if [[ ! -d "${XDG_DESKTOP_DIR}" ]]; then
    # If the directory does not exist, try to create it.
    # If creation fails or is not possible, then exit.
    mkdir -p "${XDG_DESKTOP_DIR}" || exit 1
fi

# Write the content to the file on the desktop
echo "$MESSAGE_CONTENT" > "$DESKTOP_DIR/$OUTPUT_FILENAME"

# Set read permissions for everyone
chmod a+r "$DESKTOP_DIR/$OUTPUT_FILENAME"

exit 0
