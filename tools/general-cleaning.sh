#!/bin/bash

# =================================================================
#                         Vérification root
# =================================================================

[ "$(id -u)" -ne 0 ] && { echo "Ce script doit être lancé en root." >&2; exit 1; }


# =================================================================
#          Fonctions de nettoyage avant remastérisation
# =================================================================

# Fonction pour supprimer des fichiers ou répertoires selon un motif
cleanup_by_pattern() {
    local search_pattern="$1"
    local search_path="$2"
    local tmp_file
    tmp_file=$(mktemp)
    trap 'rm -f "$tmp_file"' EXIT

    echo "Recherche des éléments '${search_pattern}' dans '${search_path}'..."

    find "${search_path}" \( -path /proc -o -path /sys -o -path /dev \) -prune -o \
        -name "${search_pattern}" -print > "$tmp_file" 2>/dev/null

    local files_found
    files_found=$(wc -l < "$tmp_file")

    if [ "$files_found" -eq 0 ]; then
        echo "Aucun élément '${search_pattern}' trouvé."
        return 1
    fi

    echo "--- $files_found éléments trouvés. Voici la liste: ---"
    cat "$tmp_file"=> Supprime aussi le répertoire docker ! Donc les sites associés comme Sentry ...

    read -p "Voulez-vous vraiment supprimer ces éléments ? (o/n) " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Oo]$ ]]; then
        echo "Suppression des éléments..."
        while read -r item; do
            if [ -f "$item" ]; then
                if rm "$item"; then
                    echo "Supprimé (fichier): $item"
                else
                    echo "ERREUR: impossible de supprimer $item" >&2
                fi
            elif [ -d "$item" ]; then
                if rm -r "$item"; then
                    echo "Supprimé (répertoire): $item"
                else
                    echo "ERREUR: impossible de supprimer $item" >&2
                fi
            fi
        done < "$tmp_file"
        echo "Nettoyage terminé pour les éléments '${search_pattern}'."
    else
        echo "Suppression annulée. Aucun élément n'a été modifié."
    fi

    return 0
}

# Fonction pour supprimer les fichiers dans des répertoires spécifiques
cleanup_files_in_dirs() {
    local dirs=("$@")
    local tmp_file
    tmp_file=$(mktemp)
    trap 'rm -f "$tmp_file"' EXIT

    echo "Recherche de fichiers inutiles dans les répertoires spécifiés..."

    for dir in "${dirs[@]}"; do
        echo "--- Traitement du répertoire ${dir} ---"
        find "$dir" -type f > "$tmp_file" 2>/dev/null
        local files_found
        files_found=$(wc -l < "$tmp_file")

        if [ "$files_found" -eq 0 ]; then
            echo "Aucun fichier à supprimer dans ${dir}."
            continue
        fi

        echo "$files_found fichiers trouvés. Voici la liste:"
        cat "$tmp_file"

        read -p "Voulez-vous vraiment supprimer ces fichiers ? (o/n) " -n 1 -r
        echo

        if [[ $REPLY =~ ^[Oo]$ ]]; then
            echo "Suppression des fichiers..."
            while read -r file; do
                if [ -f "$file" ]; then
                    if rm "$file"; then
                        echo "Supprimé: $file"
                    else
                        echo "ERREUR: impossible de supprimer $file" >&2
                    fi
                fi
            done < "$tmp_file"
            echo "Nettoyage terminé pour ${dir}."
        else
            echo "Suppression annulée."
        fi
    done
}


# =================================================================
#                        Exécution du script
# =================================================================

# 1. Nettoyage de l'historique de l'utilisateur root
echo "--- Nettoyage de l'historique des commandes de l'utilisateur root ---"
> /root/.bash_history
echo "/root/.bash_history vidé."

echo "========================================="

# 1b. Nettoyage des fichiers de trace de l'utilisateur root
echo "--- Nettoyage des fichiers de trace root ---"
for f in \
    /root/.local/share/recently-used.xbel \
    /root/.local/share/mc/filepos \
    /root/.local/share/mc/history; do
    if [ -f "$f" ]; then
        > "$f"
        echo "Vidé : $f"
    fi
done

# 2. Nettoyage des paquets en cache avec apt
echo "Nettoyage des paquets en cache avec 'apt clean' et 'apt autoclean'..."
read -p "Voulez-vous lancer le nettoyage APT ? (o/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Oo]$ ]]; then
    apt clean
    apt autoclean
    rm -f /var/cache/apt/pkgcache.bin /var/cache/apt/srcpkgcache.bin
    echo "Nettoyage APT terminé."
else
    echo "Nettoyage APT annulé."
fi

# 2b. Purge des paquets résiduels (rc)
RESIDUALS=$(dpkg -l | awk '/^rc/ {print $2}')

if [ -n "$RESIDUALS" ]; then
    echo "Paquets résiduels détectés :"
    echo "$RESIDUALS"
    read -p "Voulez-vous les purger ? (o/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Oo]$ ]]; then
        apt purge $RESIDUALS
        echo "Purge des paquets résiduels terminée."
    else
        echo "Purge annulée."
    fi
else
    echo "Aucun paquet résiduel détecté."
fi

echo "========================================="

# 3. Nettoyage des fichiers dans des répertoires spécifiques
dirs_to_clean=(
    "/var/log"
    "/var/backups"
    "/var/lib/apt/lists"
    "/var/cache/system-tools-backends/backup/"
)

cleanup_files_in_dirs "${dirs_to_clean[@]}"

echo "========================================="

# 4. Nettoyage des fichiers *.bak, *.old et *.dpkg-dist
cleanup_by_pattern "*.bak" "/"
cleanup_by_pattern "*.old" "/"
cleanup_by_pattern "*.dpkg-dist" "/"

echo "========================================="

# 4b. Suppression des liens symboliques cassés
cleanup_by_pattern_symlinks() {
    local tmp_file
    tmp_file=$(mktemp)
    trap 'rm -f "$tmp_file"' EXIT

    echo "Recherche des liens symboliques cassés..."

find / \( -path /proc -o -path /sys -o -path /dev -o -path /run -o -path /etc/systemd -o -path /usr/lib/systemd -o -path /usr/share/doc -o -path /usr/share/terminfo -o -path /var/lib -o -path /usr/lib -o -path /lib/modules/ \) -prune -o \
    -xtype l -print > "$tmp_file" 2>/dev/null

    local files_found
    files_found=$(wc -l < "$tmp_file")

    if [ "$files_found" -eq 0 ]; then
        echo "Aucun lien symbolique cassé trouvé."
        return 0
    fi

    echo "--- $files_found liens cassés trouvés. Voici la liste: ---"
    cat "$tmp_file"

    read -p "Voulez-vous vraiment les supprimer ? (o/n) " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Oo]$ ]]; then
        while read -r item; do
            if rm "$item"; then
                echo "Supprimé: $item"
            else
                echo "ERREUR: impossible de supprimer $item" >&2
            fi
        done < "$tmp_file"
        echo "Nettoyage des liens cassés terminé."
    else
        echo "Suppression annulée."
    fi
}

cleanup_by_pattern_symlinks

# 5. Suppression des paquets noyau orphelins
CURRENT=$(uname -r)
VERSION=$(echo "$CURRENT" | grep -oP '^\d+\.\d+\.\d+-\d+')

ORPHANS=$(dpkg --list 'linux-image-[0-9]*.[0-9]*' | \
    awk '/^ii/ {print $2}' | \
    grep -v "$VERSION")

if [ -n "$ORPHANS" ]; then
    echo "Paquets noyau orphelins détectés :"
    echo "$ORPHANS"
    read -p "Voulez-vous les supprimer avec apt purge --autoremove ? (o/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Oo]$ ]]; then
        apt purge --autoremove -y $ORPHANS
    else
        echo "Suppression annulée."
    fi
else
    echo "Aucun paquet noyau orphelin détecté."
fi

echo "========================================="

# 6. Rappel pour la vérification manuelle
echo "RAPPEL: N'oubliez pas de vérifier manuellement le nombre de noyaux Linux installés."
echo "Pour cela, vérifiez le contenu du répertoire /boot."

