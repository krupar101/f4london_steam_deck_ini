#!/bin/bash

# Define the paths
my_path="$HOME/Games/Heroic/Prefixes/default"
my_path2="$HOME/Games/Heroic/Fallout 4 GOTY"

# Check if "Fallout London" folder exists in my_path
if [ -d "$my_path/Fallout London" ]; then
  # Rename it to "Fallout 4 Game of the Year Edition"
	# Check if "Fallout 4 Game of the Year Edition" folder exists in my_path
	if [ -d "$my_path/Fallout 4 Game of the Year Edition" ]; then
	  # Rename it to "Fallout 4 Game of the Year Edition old"
	  mv "$my_path/Fallout 4 Game of the Year Edition" "$my_path/Fallout 4 Game of the Year Edition old"
    	  mv "$my_path/Fallout London" "$my_path/Fallout 4 Game of the Year Edition"
	fi
fi

# Check if the files exist
if [ -f "$my_path2/Fallout4Launcher.exe" ] && [ -f "$my_path2/f4se_loader.exe" ]; then
  # Rename the files
  mv "$my_path2/Fallout4Launcher.exe" "$my_path2/Fallout4Launcher.exe.old"
  mv "$my_path2/f4se_loader.exe" "$my_path2/Fallout4Launcher.exe"
fi

echo "Script completed successfully."

