#!/bin/bash
#
# Script to create an info file on the Live desktop.
#

# Define the content of the info file
MESSAGE_CONTENT="
(EN) Welcome to Bento antiX 32bits!

The default password for root is \"root\"
The default password for the user is \"demo\"

The installer and most administration tools usually need only the default user password.
You will be invited to create your own during installation.

We hope you enjoy this distribution.

---

/!\\ Post-installation Information /!\\

This file contains the details of temporary passwords specific
to the Live session.

If you choose to install the system on your hard drive and
\"keep changes made live\", THIS FILE WILL END UP ON YOUR DESKTOP
after installation.

You will then need to delete it manually once the installation
is complete and the new system has booted.

---

(FR) Bienvenue sur Bento antiX 32bits !

Le mot de passe par défaut pour root est \"root\"
Le mot de passe par défaut pour l'utilisateur est \"demo\"

L'installeur et la plupart des outils d'administration ne nécessitent
généralement que le mot de passe de l'utilisateur par défaut.
Vous serez invité à créer les vôtres durant l'installation.

Nous espérons que vous apprécierez cette distribution.

---

/!\ Information pour la post-installation /!\

Ce fichier contient les détail des mots de passe temporaires spécifiques
à la session Live.

Si vous choisissez d'installer le système sur votre disque dur et
de \"conserver les modifications faites en Live\", CE FICHIER SE
RETROUVERA SUR VOTRE BUREAU après l'installation.

Vous devrez alors le supprimer manuellement une fois l'installation
terminée et le nouveau système démarré.

"

# Define the output file name
OUTPUT_FILENAME="INSTALLATION.TXT"

# --- Live Session Check ---
# Are we in a live session? We want this to happen only in this case
if [ ! -d "/live" ]; then
    exit 0
fi

# --- Determine the active graphical user and their home directory ---
# Find the display number, typically :0 or :1
# 'who' can show active users and their display, 'logname' gets login name
# However, for scripts run via xdg/autostart, the display and user should already be set.
# A more robust way to find the actual logged-in graphical user:
GRAPHICAL_USER=$(logname 2>/dev/null || who | awk '{print $1}' | sort -u | head -n 1)

# Fallback if logname/who fails or returns multiple users (e.g., 'demo')
if [ -z "$GRAPHICAL_USER" ]; then
    # Common antiX live user
    GRAPHICAL_USER="demo"
fi

# Get the home directory of that user
USER_HOME=$(eval echo "~$GRAPHICAL_USER")

# --- Desktop Directory Determination ---
# Ensure user-dirs are updated for the target user if necessary
# This might require running as the user, which is complex from a root-run script.
# A simpler approach is to assume standard Desktop path for the target user.

DESKTOP_DIR="${USER_HOME}/Desktop" # Default to ~/Desktop for the target user

# Create the Desktop directory if it doesn't exist for the target user
if [ ! -d "$DESKTOP_DIR" ]; then
    mkdir -p "$DESKTOP_DIR"
    # Set appropriate ownership if created by root
    chown "$GRAPHICAL_USER":"$GRAPHICAL_USER" "$DESKTOP_DIR"
fi

# --- Write the content to the file on the desktop ---
echo "$MESSAGE_CONTENT" > "$DESKTOP_DIR/$OUTPUT_FILENAME"

# Set ownership and permissions for the created file
chown "$GRAPHICAL_USER":"$GRAPHICAL_USER" "$DESKTOP_DIR/$OUTPUT_FILENAME"
chmod a+r "$DESKTOP_DIR/$OUTPUT_FILENAME"

exit 0
