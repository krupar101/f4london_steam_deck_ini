#!/bin/bash

# Define file paths
file1="/home/deck/Games/Heroic/Prefixes/default/Fallout 4 Game of the Year Edition/pfx/drive_c/users/steamuser/Documents/My Games/Fallout4/Fallout4Prefs.ini"
file2="/home/deck/Games/Heroic/Prefixes/default/Fallout London/pfx/drive_c/users/steamuser/Documents/My Games/Fallout4/Fallout4Prefs.ini"

# Check if both files exist
if [[ -f "$file1" && -f "$file2" ]]; then
    # Ask the user if they want to update Fallout 4 settings
    read -p "Do you want to update Fallout 4 settings from the main launcher? (y/n): " response
    case "$response" in
        y|Y|yes|Yes|YES)
            # Replace the file
            cp "$file1" "$file2"
            echo "Fallout 4 settings have been updated."
            ;;
        *)
            echo "No changes made."
            ;;
    esac
else
    echo "One or both of the required files do not exist."
fi

