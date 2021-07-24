#!/bin/bash

# Get the path of this script
script_dir="$(dirname "$(realpath "$0")")"

languages_dir="$1"
if [ -z "$languages_dir" ]
then
    echo "Le script prend en argument le chemin du dossier de traductions à traiter." >&2
    exit 1
elif [ ! -e "$languages_dir" ]
then
    echo "Le dossier ou fichier indiqué: \"$languages_dir\" ne peut pas être trouvé." >&2
    exit 1
fi

# If no filter is given as a second argument, use a default filter of common translation file extensions.
filter="${2-.php$|.json$|.js$|.po$|.yml$}"

# Create the backup directories from $languages_dir names
backup_dir="$script_dir/translation_backup-${languages_dir//\//_}"
mkdir -p "$backup_dir"


# Build the list of file to modify
IFS_backup=$IFS; IFS=$'\n'
# Look for all files (not directories) that match the filter
files_list=( $(find "$languages_dir" -type f -print | grep --extended-regexp "$filter") )
IFS=$IFS_backup


# Check if there's anything new in the translation files
# Make a checksum of each file in the list, then a checksum of all these cheksums.
# That give us a checksum for all the files at once
current_checksum=$(find "${files_list[@]}" -exec md5sum {} \; | md5sum | cut -d' ' -f1)
checksum_file="$script_dir/translation_checksum-${languages_dir//\//_}"
last_checksum=$(cat "$checksum_file" 2> /dev/null )

if [ "$current_checksum" == "$last_checksum" ]
then
    echo "Rien de nouveau, la somme de contrôle n'a pas changé."
    # No new files to process
    exit 0
fi

# Store the new checksum for the next execution.
echo "$current_checksum" > "$checksum_file"


# Compile the cleaning strings for better performances
source "$script_dir/chaines_epicene.sh"
# Remove comments
chaine_a_nettoyer="$(echo "$chaine_a_nettoyer" | sed --regexp-extended "/^#/d")"
# And empty lines
chaine_a_nettoyer="$(echo "$chaine_a_nettoyer" | sed --regexp-extended "/^$/d")"
# We use 2 arrays
declare -a cleaning_array_seek
declare -a cleaning_array_destroy
quick_search=""
while read values
do
    # Keep only the value before the marker <::>
    seek="${values%%<::>*}"
    seek="${seek#>}"
    # And the value after
    destroy="${values##*<::>}"
    # Then remove the ending marker <
    destroy="${destroy%<}"

    # Put in each array the string to find and the string to replace with
    cleaning_array_seek+=( "$seek" )
    cleaning_array_destroy+=( "$destroy" )
    # And build a quick search string to quickly find culprit lines
    quick_search+="$seek|"
done <<< "$(echo "$chaine_a_nettoyer")"

# Remove the ending |
quick_search="${quick_search%|}"


> "$script_dir/diff_result"

echo "> Travail en cours sur le dossier $languages_dir..." >&2
# Read each file to clean them
for file in "${files_list[@]}"
do
    # Check the file against the quick search string to find if there's anything to remove in that file
    if grep --extended-regexp --quiet "$quick_search" "$file"
    then
        echo ">> Modification en cours sur le fichier $file..." >&2
        
        # Backup the original file
        mkdir -p "${backup_dir}$(dirname "${file}")"
        cp "$file" "${backup_dir}${file}"
        # Clean the whole file to remove inclusive writings.
        for i in $(seq 0 $(( ${#cleaning_array_seek[@]} - 1)) )
        do
            sed --in-place --regexp-extended "s@${cleaning_array_seek[$i]}@${cleaning_array_destroy[$i]}@g" "$file"
        done

        # Créer un diff du fichier modifié par rapport à la version originale
        git --no-pager diff --unified=0 --word-diff=color --no-index "${backup_dir}${file}" "$file" >> "$script_dir/diff_result"

        # Compile the .mo file from the .po
        if echo "$file" | grep --quiet ".po$"
        then
            compiled_mo_file="$(dirname "$file")/$(basename --suffix=.po "$file").mo"
            msgfmt --output-file="$compiled_mo_file" "$file"
        fi

        echo ">>> Fichier $file terminé." >&2
    fi
done


# Print the diff to check the modifications made by the script
cat "$script_dir/diff_result" >&2
