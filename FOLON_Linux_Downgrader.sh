#!/usr/bin/env bash

echo "---------------------"
echo ""
echo "Fallout 4 Downgrader for Steam Deck / Linux by krupar"
echo ""
echo "---------------------"
sleep 1
echo "---------------------"
echo ""
echo "Buy me a coffee @ https://ko-fi.com/krupar"
echo ""
echo "---------------------"
sleep 1

F4_LAUNCHER_NAME="Fallout4Launcher.exe"
SSD_F4_LAUNCHER_FILE="$HOME/.steam/steam/steamapps/common/Fallout 4/$F4_LAUNCHER_NAME"
DOWNGRADE_LIST_PATH="$HOME/Downloads/folon_downgrade.txt"
F4_INSTALLED=0
CUSTOM_PATH=0

# 1. Check if SD Card is installed

    SD_MOUNT=$(findmnt -rn -o TARGET | grep '/run/media')
    echo "Checking if SD Card is mounted [Handheld Specific]."
    if [ -n "$SD_MOUNT" ]; then
        echo "SD Card is mounted at: $SD_MOUNT"
        SD_CARD_F4_LAUNCHER_FILE="$SD_MOUNT/steamapps/common/Fallout 4/$F4_LAUNCHER_NAME"
    else
        echo "SD Card is not mounted [Handheld Specific]."
    fi

# 2. Check if Fallout 4 is installed in any of the locations (SD / SSD)

    if [ -e "$SSD_F4_LAUNCHER_FILE" ]; then
        echo "Fallout 4 recognized to be installed on Internal SSD"
            FALLOUT_4_DIR="$HOME/.steam/steam/steamapps/common/Fallout 4"
            F4_INSTALLED=1
    elif [ -e "$SD_CARD_F4_LAUNCHER_FILE" ]; then
        echo "Fallout 4 recognized to be installed on SD Card"
            FALLOUT_4_DIR="$SD_MOUNT/steamapps/common/Fallout 4"
            F4_INSTALLED=1 
    else
            echo "Steam version of Fallout 4 not recognized to be installed on this device."
    fi


# 3. Display a message: Fallout 4 Steam installation Found - Do you want to downgrade it? options: Yes. / Select a different path for Fallout 4 Files.

    if [ "$F4_INSTALLED" -eq 1 ]; then
    	response=$(zenity --forms --title="Fallout 4 Files Confirmation" --width="450" --text="Steam Version of Fallout 4 is recognized to be installed on this device\nDo you want to downgrade this version?\n\n$FALLOUT_4_DIR" --ok-label="Proceed" --cancel-label="Choose custom F4 installation path")
    		if [ $? -eq 0 ]; then
    		    echo "User selected to proceed with the recognized path."
    		else
                echo "User selected to define a custom installation path"
                CUSTOM_PATH=1
    		fi
    else
        echo "Default to custom path as Steam version of Fallout 4 was not found on device."
        CUSTOM_PATH=1
    fi

# 4. While function that will allow to drop Fallout 4 Directory that user wants to downgrade.

    if [ "$CUSTOM_PATH" -eq 1 ]; then

		while true; do
		    # Prompt the user to drop a file and read the input
		    echo ""
		    echo "Drop the 'Fallout 4' installation folder file here:"
		    read -r dropped_dir
		
            # Remove single quotes from the file path if they exist
		    dropped_dir="${dropped_dir//\'/}"

            # Check if the input is empty
            if [[ -z "$dropped_dir" ]]; then
                echo "Error: No directory provided. Please drop a directory."
                continue
            fi

            # Check if the specific file exists in the directory
            if [[ ! -e "$dropped_dir/$F4_LAUNCHER_NAME" ]]; then
                echo "Error: File '$F4_LAUNCHER_NAME' does not exist in the provided directory."
                continue
            fi
            FALLOUT_4_DIR=$dropped_dir
		    break
		done

    fi
# 5. Ask about space / as where user wants to download files if SD card is present. 

    if [ -z "$STEAMCMD_DIR" ]; then
        if [ -d "$SD_MOUNT" ]; then
    	    echo "SD Card available [Handheld Specific]."
    	response=$(zenity --forms --title="Choose file download location" --width="450" --text="To downgrade Fallout 4 the script needs to download ~35GB of files.\nPlease ensure you have that much space available on the preferred device (SSD/microSD Card).\n\nWhere would you like to download the files?\n" --ok-label="Internal SSD" --cancel-label="microSD Card")
    		if [ $? -eq 0 ]; then
    		        echo "Internal SSD Selected"
                    STEAMCMD_DIR="$HOME/Downloads/SteamCMD"
    		else
                echo "microSD Card Selected"
                if [ -d "$SD_MOUNT" ]; then 
                    echo "set the path to the default sd card location"
                    STEAMCMD_DIR="$SD_MOUNT/Downloads/SteamCMD"
                else
                    echo "ERROR: This error should never be shown. If it is it means that microsd card was wrongly detected in depot_download_location_choice function."
                fi
    		fi
    	else
    	    echo "SD Card not detected - Default to Internal SSD"
    		zenity --info --title="Download process message" --width="450" --text="To downgrade Fallout 4 the script needs to download ~35GB of files.\nPlease ensure you have that much space available on your SSD.\n\nConfirm this window only after you make sure you have enough space." 2>/dev/null
        	STEAMCMD_DIR="$HOME/Downloads/SteamCMD"
        fi
    else
        echo "Depot download location is set to $STEAMCMD_DIR"
    fi

# 6. Download Depots
echo "Setting up downgrade-list..."
cat <<EOL > "$DOWNGRADE_LIST_PATH"
download_depot 377160 377162 5847529232406005096
download_depot 377160 435870 1691678129192680960
download_depot 377160 435871 5106118861901111234
download_depot 377160 435880 1255562923187931216
download_depot 377160 435882 8482181819175811242
download_depot 377160 480630 5527412439359349504
download_depot 377160 480631 6588493486198824788
download_depot 377160 393885 5000262035721758737
download_depot 377160 393895 7677765994120765493
download_depot 377160 435881 1207717296920736193
download_depot 377160 377164 2178106366609958945
download_depot 377160 490650 4873048792354485093
download_depot 377160 377161 7497069378349273908
download_depot 377160 377163 5819088023757897745
quit
EOL

echo "Setting up SteamCMD..."
mkdir -p "$STEAMCMD_DIR"
cd "$STEAMCMD_DIR" || { echo "Failed to change directory to $STEAMCMD_DIR"; exit 1; }
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

echo "Please enter your Steam login credentials."
echo "Note: Your login details are secure and will NOT be stored."

# Loop until a non-empty username is entered
while true; do
    username=$(zenity --entry --title="Steam Username" --width="450" --text="Enter name of your Steam user:")

    if [ -n "$username" ]; then
    break
    else
    zenity --error --title="Input Error" --text="Username cannot be empty. Please enter your Steam username." --width="450"
    fi
done

# Loop until a non-empty password is entered
while true; do
    password=$(zenity --password --title="Steam Password" --width="450" --text="Enter your Steam user password to install required dependencies" 2>/dev/null)

    if [ -n "$password" ]; then
    break
    else
    zenity --error --title="Input Error" --text="Password cannot be empty. Please enter your Steam user password." --width="450"
    fi
done

    echo "Running SteamCMD with provided credentials..."
    chmod +x "$STEAMCMD_DIR/steamcmd.sh"
    "$STEAMCMD_DIR/steamcmd.sh" +login "$username" "$password" +runscript "$DOWNGRADE_LIST_PATH"

	expected_files=(
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_480631/Data/DLCworkshop03 - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_480631/Data/DLCworkshop03.cdx"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_480631/Data/DLCworkshop03 - Geometry.csg"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_480631/Data/DLCworkshop03 - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_480630/Data/DLCworkshop02.esm"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_480630/Data/DLCworkshop02 - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_480630/Data/DLCworkshop02 - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435881/Data/DLCCoast - Geometry.csg"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435881/Data/DLCCoast - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435881/Data/DLCCoast - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435881/Data/DLCCoast.cdx"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_490650/Data/DLCNukaWorld - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_490650/Data/DLCNukaWorld - Geometry.csg"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_490650/Data/DLCNukaWorld - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_490650/Data/DLCNukaWorld.cdx"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435871/Data/DLCRobot - Voices_en.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435871/Data/DLCRobot.esm"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377162/Fallout4.exe"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435870/Data/DLCRobot - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435870/Data/DLCRobot - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435870/Data/DLCRobot - Geometry.csg"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435870/Data/DLCRobot.cdx"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435880/Data/DLCworkshop01.esm"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435880/Data/DLCworkshop01 - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435880/Data/DLCworkshop01 - Geometry.csg"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435880/Data/DLCworkshop01 - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435880/Data/DLCworkshop01.cdx"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_393895/Data/DLCNukaWorld.esm"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_393895/Data/DLCNukaWorld - Voices_en.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377164/Fallout4_Default.ini"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377164/Data/Video/Intro.bk2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377164/Data/Video/Endgame_MALE_A.bk2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377164/Data/Video/Endgame_FEMALE_A.bk2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377164/Data/Video/Endgame_FEMALE_B.bk2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377164/Data/Video/Endgame_MALE_B.bk2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377164/Data/Fallout4 - Voices.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377161/Data/Fallout4 - Sounds.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377161/Data/Fallout4 - Meshes.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377161/Data/Video/INTELLIGENCE.bk2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377161/Data/Video/ENDURANCE.bk2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377161/Data/Video/MainMenuLoop.bk2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377161/Data/Video/STRENGTH.bk2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377161/Data/Video/LUCK.bk2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377161/Data/Video/PERCEPTION.bk2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377161/Data/Video/CHARISMA.bk2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377161/Data/Video/GameIntro_V3_B.bk2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377161/Data/Video/AGILITY.bk2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377161/installscript.vdf"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435882/Data/DLCCoast - Voices_en.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_435882/Data/DLCCoast.esm"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/bink2w64.dll"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/GFSDK_SSAO_D3D11.win64.dll"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/flexExtRelease_x64.dll"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/nvToolsExt64_1.dll"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Fallout4/Fallout4Prefs.ini"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Low.ini"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/steam_api64.dll"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Fallout4Launcher.exe"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/flexRelease_x64.dll"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Ultra.ini"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/nvdebris.txt"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Textures9.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4038-HorseArmor - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Shaders.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Textures2.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccFSVFO4002-MidCenturyModern - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Textures5.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4003-PipBoy(Camo01) - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - MeshesExtra.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Textures4.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4003-PipBoy(Camo01) - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Animations.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4006-PipBoy(Chrome) - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccFRSFO4001-HandmadeShotgun - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4004-PipBoy(Camo02) - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4016-Prey - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Startup.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4020-PowerArmorSkin(Black) - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Meshes.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Textures1.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Nvflex.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4019-ChineseStealthArmor - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccFSVFO4001-ModularMilitaryBackpack - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4006-PipBoy(Chrome) - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccFSVFO4002-MidCenturyModern - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4020-PowerArmorSkin(Black) - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Materials.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Textures6.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Interface.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4019-ChineseStealthArmor - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Geometry.csg"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccFRSFO4001-HandmadeShotgun - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4004-PipBoy(Camo02) - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4018-GaussRiflePrototype - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccFSVFO4001-ModularMilitaryBackpack - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4001-PipBoy(Black) - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Misc.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4001-PipBoy(Black) - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4044-HellfirePowerArmor - Main.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4.cdx"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4038-HorseArmor - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Textures3.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4016-Prey - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4.esm"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4018-GaussRiflePrototype - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Textures8.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Textures7.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/ccBGSFO4044-HellfirePowerArmor - Textures.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/GFSDK_GodraysLib.x64.dll"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Medium.ini"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/msvcr110.dll"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Fallout4.ccc"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/msvcp110.dll"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/cudart64_75.dll"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/High.ini"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_393885/Data/DLCworkshop03 - Voices_en.ba2"
    "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_393885/Data/DLCworkshop03.esm"
	)

	# Check if all expected files exist
	for file in "${expected_files[@]}"; do
	    if [ ! -f "$file" ]; then
		echo "ERROR: Download progress was not successful. Please run the script again."
		exit 1
	    fi
	done
    	echo "All files downloaded successfully."

# 7. Move files

    echo "Moving downloaded content and cleaning up..."
    rsync -av --remove-source-files "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/"*/ "$FALLOUT_4_DIR/"

    # Manually move and overwrite the Fallout4 - Meshes.ba2 file
    if [ -f "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Meshes.ba2" ]; then
        mv -f "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/depot_377163/Data/Fallout4 - Meshes.ba2" "$FALLOUT_4_DIR/Data/"
    fi

    # Remove empty directories
    find "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/" -type d -empty -delete

    # Check if there are any files left in the subfolders
    if find "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/" -type f | read; then
        echo "Error: One or more files need to be moved manually."
        echo "File(s) still present:"
        find "$STEAMCMD_DIR/linux32/steamapps/content/app_377160/" -type f
        zenity --info --title="Manual Intervention Required" --width="450" --text="Some files could not be moved. Please move the remaining files manually from '$STEAMCMD_DIR/linux32/steamapps/content/app_377160/' to '$FALLOUT_4_DIR'. However, do not move folders starting with 'depot_'. Move their content. Normally it should only be one file, called Fallout4 - Meshes.ba2 that has to go into /Data/.\n\nClick OK when you have finished moving the files to continue." 2>/dev/null
    else
        rm -rf "$STEAMCMD_DIR"
        rm "$DOWNGRADE_LIST_PATH"
    fi

# 8. Remove cc* files 

    CC_FOLDER_LOCATION="$FALLOUT_4_DIR/Data"

    # Check for files starting with cc in the folder
    FILES=$(find "$CC_FOLDER_LOCATION" -name 'cc*' 2>/dev/null)

    if [ -n "$FILES" ]; then
        rm -f "${CC_FOLDER_LOCATION}/cc"*
        echo "Creation Club files have been removed."
    else
        # No files found
        echo "No Creation Club items are installed."
    fi

# 9. Downgrade completed successfully. 
    echo "Downgrade completed successfully."
    text="Downgrade completed successfully."
    zenity --info \
        --title="Overkill" \
        --width="450" \
        --text="$text" 2>/dev/null

exit
