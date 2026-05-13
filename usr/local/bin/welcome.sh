#!/bin/bash
#
# Script to create an information file on the Live desktop.

# Exit immediately if a command exits with a non-zero status.
set -e

# Define the content of the info file
MESSAGE_CONTENT="
(EN) Welcome to Bento antiX!

The default password for root is \"root\"
The default password for the user is \"demo\"

The installer and most administration tools usually need only the default user password.
You will be invited to create your own during installation.

We hope you enjoy this distribution.
---

/!\ Post-installation Information /!\

This file contains the details of temporary passwords specific
to the Live session.

If you choose to install the system on your hard drive and
\"keep changes made live\", THIS FILE WILL END UP ON YOUR DESKTOP
after installation.

You will then need to delete it manually once the installation
is complete and the new system has booted.

-

This antiX spinoff is configured for all available languages. After installation
please use "dpkg-reconfigure locales" (with admin rights) to setup your own language
system wide, and avoid having the long list of all languages applied to the system
when updating or adding packages.

---

(FR) Bienvenue sur Bento antiX !

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
de \"consolider les modifications faites en Live\", CE FICHIER SE
RETROUVERA SUR VOTRE BUREAU après l'installation.

Vous devrez alors le supprimer manuellement une fois l'installation
terminée et le nouveau système démarré.

-

Cette version dérivée d'antiX est configurée pour inclure toutes les langues
disponibles. Après l'installation, veuillez utiliser la commande "dpkg-reconfigure locales"
(avec les droits root) afin de paramétrer votre propre langue pour l'ensemble du
système, et éviter d'avoir la longue liste de langues configurées lors des mises
à jour ou de l'ajout de nouveaux paquets.

"

# Output file name
OUTPUT_FILENAME="INSTALLATION.TXT"

# The script should only run in a Live session.
if [ ! -d "/live" ]; then
    echo "Script is not executed in a Live session. Exiting."
    exit 0
fi

# The default user in antiX live distributions and live respins
USER="demo"

# Use XDG_DESKTOP_DIR, else fall back to the standard 'demo' user path
DESKTOP_DIR="${XDG_DESKTOP_DIR:-/home/${USER}/Desktop}"

# We write the content to the file on the desktop
echo "$MESSAGE_CONTENT" | tee "$DESKTOP_DIR/$OUTPUT_FILENAME" > /dev/null

# Set rights and permissions for the created file 
chown "$USER":"$USER" "$DESKTOP_DIR/$OUTPUT_FILENAME"
.
chmod a+r "$DESKTOP_DIR/$OUTPUT_FILENAME"

exit 0
