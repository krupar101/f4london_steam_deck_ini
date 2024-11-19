#!/bin/bash
echo "---------------------"
echo ""
echo "Fallout London optimization script for Steam Deck by krupar"
echo ""
echo "---------------------"
sleep 1
echo "---------------------"
echo ""
echo "Buy me a coffee @ https://ko-fi.com/krupar"
echo ""
echo "---------------------"
sleep 1

HEROIC_CONFIG_FILE="$HOME/.var/app/com.heroicgameslauncher.hgl/config/heroic/gog_store/installed.json"
F4_LAUNCHER_NAME="Fallout4Launcher.exe"
SSD_F4_LAUNCHER_FILE="$HOME/.steam/steam/steamapps/common/Fallout 4/$F4_LAUNCHER_NAME"
HEROIC_PREFIX_FILE="$HOME/.var/app/com.heroicgameslauncher.hgl/config/heroic/GamesConfig/1998527297.json"

select_gog_or_steam_to_update_or_install() {
	response=$(zenity --question --text="Which Version of Fallout 4 do you own?" --width="450" --ok-label="GoG" --cancel-label="Steam" --title="Fallout 4 version selection")

	# Check the response
	if [ $? -eq 0 ]; then
		echo "GoG Selected"
		F4_VERSION="GOG"
	else
		echo "Steam selected"
		F4_VERSION="STEAM"
	fi
}

check_if_sd_card_is_mounted_and_set_proton_f4_paths() {
	#Function to automatically detect the SD card mount location and set Proton Directory and Fallout 4 launcher Directory for installation detection
	SD_MOUNT=$(findmnt -rn -o TARGET | grep '/run/media' | sed 's/\\x20/ /g')

	if [ -n "$SD_MOUNT" ]; then
		echo "SD Card is mounted at: $SD_MOUNT"
		SD_CARD_F4_LAUNCHER_FILE="$SD_MOUNT/steamapps/common/Fallout 4/$F4_LAUNCHER_NAME"
	else
		echo "SD Card is not mounted."
	fi

}

find_fallout4_heroic_install_path() {
	# Check if the file exists
	if [[ ! -f "$HEROIC_CONFIG_FILE" ]]; then
		echo "Fallout 4 not recognized to be installed in Heroic Launcher."
		exit
	fi

	# Search for the install_path for the game "Fallout London"
	install_path=$(jq -r '.installed[] | select(.install_path | contains("Fallout 4")) | .install_path' "$HEROIC_CONFIG_FILE")

	# Check if the install_path was found
	if [[ -n "$install_path" ]]; then
		echo "Fallout 4 installation path found."
		FALLOUT_4_DIR="$install_path"
	else
		echo "Fallout 4 not recognized to be installed in Heroic Launcher. Install it and try again."
		exit
	fi
}

find_f4_heroic_prefix_location() {
	if [[ ! -f "$HEROIC_PREFIX_FILE" ]]; then
		echo "ERROR: Heroic Prefix File not found."
		exit
	fi

	# Extract the winePrefix using jq
	echo "Fallout 4 recognized to be installed in Heroic Launcher."
	COMPAT_DATA_PATH="$(jq -r '."1998527297".winePrefix' "$HEROIC_PREFIX_FILE")"
	WINEPREFIX="$COMPAT_DATA_PATH/pfx"
	FALLOUT_4_STEAMUSER_DIR="$WINEPREFIX/drive_c/users/steamuser"
}

check_if_fallout_4_is_installed() {
	check_if_sd_card_is_mounted_and_set_proton_f4_paths
	if [ "$F4_VERSION" == "STEAM" ]; then
		echo "F4_VERSION is STEAM"

		COMPAT_DATA_PATH="$HOME/.steam/steam/steamapps/compatdata/377160"
		WINEPREFIX="$COMPAT_DATA_PATH/pfx"
		FALLOUT_4_STEAMUSER_DIR="$WINEPREFIX/drive_c/users/steamuser"

		# Check where Steam Version of Fallout 4 is installed.
		if [ -e "$SSD_F4_LAUNCHER_FILE" ]; then
			echo "Fallout 4 recognized to be installed on Internal SSD"
			FALLOUT_4_DIR="$HOME/.steam/steam/steamapps/common/Fallout 4"

		elif [ -e "$SD_CARD_F4_LAUNCHER_FILE" ]; then
			echo "Fallout 4 recognized to be installed on SD Card"
			FALLOUT_4_DIR="$SD_MOUNT/steamapps/common/Fallout 4"
		else
			echo "ERROR: Steam version of Fallout 4 is not installed on this device."
			exit
		fi
	elif [ "$F4_VERSION" == "GOG" ]; then
		echo "F4_VERSION is GOG"
		find_fallout4_heroic_install_path
		find_f4_heroic_prefix_location
	else
		echo "Fallout 4 Installation was not found. Exiting the script"
		exit
	fi

}



select_gog_or_steam_to_update_or_install
check_if_fallout_4_is_installed


echo $FALLOUT_4_DIR

fallout4_f4se_dir="$FALLOUT_4_DIR/Data/F4SE/plugins"
fallout4_appdata_dir="$FALLOUT_4_STEAMUSER_DIR/AppData/Local/Fallout4"
fallout4_mygames_dir="$FALLOUT_4_STEAMUSER_DIR/Documents/My Games/Fallout4/"

echo $fallout4_f4se_dir
echo $fallout4_mygames_dir
echo $fallout4_appdata_dir

	response=$(zenity --question --text="Fallout 4 installation path was found.\nDo you wish to proceed with optimizing your game to the best known settings? \n\nRecognized path:\n$FALLOUT_4_DIR" --width="450" --ok-label="Proceed" --cancel-label="Cancel" --title="Confirm action")

	# Check the response
	if [ $? -eq 0 ]; then
		echo "Proceed."
	else
		exit
	fi

FOLON_OPTIMIZATION_DIR="$HOME/Downloads/folon_optimization"
ZIP_URL="https://github.com/krupar101/f4london_steam_deck_ini/raw/refs/heads/main/folon_steam_deck_optimization.zip"

# Create the downloads folder if it doesn't exist
mkdir -p "$FOLON_OPTIMIZATION_DIR"

# Download the zip file
curl -L -o "$FOLON_OPTIMIZATION_DIR/folon_steam_deck_optimization.zip" "$ZIP_URL"

# Unzip the main downloaded zip
unzip -o "$FOLON_OPTIMIZATION_DIR/folon_steam_deck_optimization.zip" -d "$FOLON_OPTIMIZATION_DIR"

# Unzip specific inner files to their respective directories
unzip -o "$FOLON_OPTIMIZATION_DIR/appdata_folon.zip" -d "$fallout4_appdata_dir"
unzip -o "$FOLON_OPTIMIZATION_DIR/documents_ini_folon.zip" -d "$fallout4_mygames_dir"
unzip -o "$FOLON_OPTIMIZATION_DIR/f4se_plugins_folon.zip" -d "$fallout4_f4se_dir"

# Clean up the downloads folder
# rm -rf "$FOLON_OPTIMIZATION_DIR"

echo "Unzipping complete and cleanup done."