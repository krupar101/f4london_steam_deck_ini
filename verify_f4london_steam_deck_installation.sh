#!/bin/bash

#Define default paths to verify
heroic_f4_path="$HOME/Games/Heroic/Fallout 4 GOTY"
heroic_f4london_steamuser="$HOME/Games/Heroic/Prefixes/default/Fallout London/pfx/drive_c/users/steamuser"
steam_f4_path="$HOME/.steam/steam/steamapps/common/Fallout 4"
steam_f4_steamuser="$HOME/.steam/steam/steamapps/compatdata/377160/pfx/drive_c/users/steamuser"
fallout_london_installer="$HOME/Games/Heroic/Fallout London"
HEROIC_CONFIG_FILE="$HOME/.var/app/com.heroicgameslauncher.hgl/config/heroic/gog_store/installed.json"

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Define paths to find installation directory.
F4_LAUNCHER_NAME="Fallout4Launcher.exe"
SSD_F4_LAUNCHER_FILE="$HOME/.steam/steam/steamapps/common/Fallout 4/$F4_LAUNCHER_NAME"
SD_CARD_F4_LAUNCHER_FILE="/run/media/mmcblk0p1/steamapps/common/Fallout 4/$F4_LAUNCHER_NAME"

find_f4london_install_path() {
# Check if the file exists
if [[ ! -f "$HEROIC_CONFIG_FILE" ]]; then
    echo "Fallout London not recognized to be installed in Heroic Launcher."
fi

# Search for the install_path for the game "Fallout London"
install_path=$(jq -r '.installed[] | select(.install_path | contains("Fallout London")) | .install_path' "$HEROIC_CONFIG_FILE")

# Check if the install_path was found
if [[ -n "$install_path" ]]; then
    echo "Fallout London installation path found."
    fallout_london_installer="$install_path"
else
    echo "Fallout London not recognized to be installed in Heroic Launcher."
    fallout_london_installer="$HOME/Games/Heroic/Fallout London"
fi
}

echo ""
echo "This script is directly related to Fallout London Steam Deck installation instructions published in this reddit thread: https://www.reddit.com/r/fallout4london/comments/1ebrc74/steam_deck_instructions/"
echo ""
echo ""

# Prompt the user for the game version
printf "${YELLOW}Fallout London installation verification script for Steam Deck.\nWhich version of the instructions did you follow? ('g' for GoG / 's' for Steam)${NC}\n"
read platform

find_f4london_install_path

# Initialize prerequisites flag
all_prerequisites_met=false

# Check the user's input and respond accordingly
if [ "$platform" == "g" ]; then
    printf "${GREEN}GoG Selected${NC}\n"

        # Define the path to the Heroic game configurations
        GAME_CONFIG_DIR="$HOME/.var/app/com.heroicgameslauncher.hgl/config/heroic/GamesConfig"

        # Define the name or identifier of your specific game
        GAME_NAME="1491728574"

        # Locate the game configuration file
        CONFIG_FILE="${GAME_CONFIG_DIR}/${GAME_NAME}.json"

        # Check if the configuration file exists
        if [ ! -f "$CONFIG_FILE" ]; then
            printf "${RED}Configuration file for $GAME_NAME (Fallout London) not found in Heroic Launcher settings.${NC}\n"
            exit 1
        fi

        # Extract the wineVersion.name from the configuration file
        WINE_VERSION_NAME=$(jq -r --arg game_id "$GAME_NAME" '.[$game_id].wineVersion.name' "$CONFIG_FILE")

        # Check if the WINE_VERSION_NAME matches the specified values
        if [ "$WINE_VERSION_NAME" == "Proton - Proton-GE-Proton9-10" ] || [ "$WINE_VERSION_NAME" == "Proton - Proton - Experimental" ]; then
            printf "${GREEN}Correct Proton version selected in Heroic Launcher: '$WINE_VERSION_NAME'${NC}\n"
        else
            printf "${RED}Wrong Proton Version selected in Heroic Launcher '$WINE_VERSION_NAME'. Please select either 'Proton - Proton-GE-Proton9-10' or 'Proton - Proton - Experimental'.${NC}\n"
            exit 1
        fi
        
            # Define the given checksum
            given_checksum="82cfb36d003551ee5db7fb3321e830e1bceed53aa74aa30bb49bf0278612a9d7"

            # Define the file path
            file_path="$heroic_f4london_steamuser/Documents/My Games/Fallout4/Fallout4.INI"

            # Compute the SHA-256 checksum of the file
            computed_checksum=$(sha256sum "$file_path" | awk '{ print $1 }')

            # Compare the computed checksum with the given checksum
            if [ "$computed_checksum" == "$given_checksum" ]; then
                printf "${GREEN}Fallout4.INI correctly placed${NC}\n"
            else
                printf "${RED}Fallout4.INI checksum does not match. Please make sure you put the file from: https://github.com/krupar101/f4london_steam_deck_ini/blob/main/Fallout4.INI inside '$heroic_f4london_steamuser/Documents/My Games/Fallout4/Fallout4.INI'.${NC}\n"
        printf "${YELLOW}Do you want to download the correct .INI file from GitHub automatically? (y/n) ${NC}\n"
        read -p "" user_input

		if [ "$user_input" == "y" ]; then
		    # Define the download URL and destination path
		    url="https://raw.githubusercontent.com/krupar101/f4london_steam_deck_ini/main/Fallout4.INI"
		    destination="$heroic_f4london_steamuser/Documents/My Games/Fallout4/Fallout4.INI"
		    
		      if [ -e "$heroic_f4london_steamuser/Documents/My Games/Fallout4/Fallout4.INI" ]; then
	    		rm "$heroic_f4london_steamuser/Documents/My Games/Fallout4/Fallout4.INI"
              fi

              if [ -e "$heroic_f4london_steamuser/Documents/My Games/Fallout4/Fallout4.ini" ]; then
	    		rm "$heroic_f4london_steamuser/Documents/My Games/Fallout4/Fallout4.ini"
              fi

		    # Download the file using wget
		    wget -O "$destination" "$url"
		    
		    # Check if the download was successful
		    if [ $? -eq 0 ]; then
                printf "${GREEN}File downloaded successfully to $destination${NC}\n"
		      
                
		    else
			printf "${RED}Failed to download the file.${NC}\n"
		    fi
		else
		    echo "User exited the script"
		    exit 1
		fi
            fi


		# Define the directories and files
		TARGET_DIR="$heroic_f4london_steamuser/AppData/Local/Fallout4"
		BACKUP_DIR="$TARGET_DIR/backup"
		FALLOUT_DIR="$fallout_london_installer/__AppData"
		FILES=("DLCList.txt" "Plugins.fo4viewsettings" "Plugins.txt" "UserDownloadedContent.txt")

		# Check if the target directory exists
		if [ -d "$TARGET_DIR" ]; then
		    printf "${GREEN}AppData Directory Exists.${NC}\n"
		else
		    printf "${YELLOW}AppData Directory does not exist. Do you want to create it? (y/n): ${NC}"
		    read create_dir
		    if [ "$create_dir" = "y" ]; then
			mkdir -p "$TARGET_DIR"
			printf "${GREEN}Directory created.${NC}\n"
		    else
			printf "${RED}You exited the script. Configuration incorrect.${NC}\n"
			exit 1
		    fi
		fi

		# Check for the existence of the files
		missing_files=0
		for file in "${FILES[@]}"; do
		    if [ ! -f "$TARGET_DIR/$file" ]; then
			missing_files=1
			break
		    fi
		done

		if [ $missing_files -eq 1 ]; then
		    # Check if backup directory exists
		    if [ ! -d "$BACKUP_DIR" ]; then
			mkdir "$BACKUP_DIR"
			# Copy existing files to backup directory
			for file in "${FILES[@]}"; do
			    if [ -f "$TARGET_DIR/$file" ]; then
				cp "$TARGET_DIR/$file" "$BACKUP_DIR/"
			    fi
			done
		    fi

		    printf "${YELLOW}The AppData files are not correctly placed. Do you want to copy them over to Fallout 4 installation directory? (y/n): ${NC}"
		    read copy_files
		    if [ "$copy_files" = "y" ]; then
			files_exist=1
			for file in "${FILES[@]}"; do
			    if [ ! -f "$FALLOUT_DIR/$file" ]; then
				files_exist=0
				break
			    fi
			done

			if [ $files_exist -eq 1 ]; then
			    for file in "${FILES[@]}"; do
				cp "$FALLOUT_DIR/$file" "$TARGET_DIR/"
			    done
			    printf "${GREEN}AppData files copied.${NC}\n"
			else
			    printf "${RED}AppData files not present in Fallout 4 installation directory.${NC}\n"
			fi
		    else
			printf "${RED}You exited the script. Configuration incorrect.${NC}\n"
			exit 1
		    fi
		else
		    printf "${GREEN}All files are present in the AppData directory.${NC}\n"
		fi


                # Define the path to the Proton prefix
                PROTONPREFIX="$HOME/Games/Heroic/Prefixes/default/Fallout London/pfx"

                # Define the path to the FAudio.dll file
                FAudio_FILE="$PROTONPREFIX/drive_c/windows/system32/FAudio.dll"

                # Check if the FAudio.dll file exists
                if [ -f "$FAudio_FILE" ]; then
                    printf "${GREEN}FAudio.dll is installed${NC}\n"  # Green for file found
                else
                    printf "${RED}FAudio.dll is not installed in the Proton prefix. Please refer to step 11 of the instructions on https://www.reddit.com/r/fallout4london/comments/1ebrc74/steam_deck_instructions/ for GoG Fallout London installation${NC}\n"  # Red for file not found
                    exit 1
                fi
                
                    # Define folder paths
                    FOLDER1="$heroic_f4_path/Data/F4SE/plugins"
                    FOLDER2="$heroic_f4_path/Data/F4SE/Plugins"

                    # Check if the "plugins" folder exists
                    if [ -d "$FOLDER1" ]; then
                        # Folder exists, prompt user to rename
                        printf "${YELLOW}It looks like you have a folder named 'plugins'. It is recommended to rename it to 'Plugins'.${NC}\n"
                        printf "${YELLOW}Do you want to rename it? (y/n) ${NC}"
                        read response

                        # Convert response to lowercase for case-insensitive comparison
                        response=$(echo "$response" | tr '[:upper:]' '[:lower:]')

                        if [ "$response" == "y" ]; then
                            # Rename the folder
                            mv "$FOLDER1" "$FOLDER2"
                            printf "${GREEN}Folder renamed to 'Plugins'.${NC}\n"
                        else
                            printf "${RED}Folder was not renamed.${NC}\n"
                        fi
                    else
                        if [ ! -d "$FOLDER1" ] && [ ! -d "$FOLDER2" ]; then
		                printf "${RED}Plugins folder does not exist under $FOLDER1. Fallout London mod might not be installed correctly.${NC}\n"
		            	exit 1
		        else
		        printf "${GREEN}Plugins folder exists.${NC}\n"
                    	fi

                    fi

                    # Define file paths
                    file1="$heroic_f4london_steamuser/Documents/My Games/Fallout4/Fallout4Custom.ini"
                    file2="$heroic_f4london_steamuser/Documents/My Games/Fallout4/Fallout4Prefs.ini"

                    # Initialize flags
                    file1_removed=false
                    file2_removed=false

                    # Check if the first file exists
                    if [ -e "$file1" ]; then
                        printf "${YELLOW}File exists:${NC} ${file1}\n"
                        # Use printf to correctly handle colors with read
                        printf "${YELLOW}For first launch of Fallout London it should be removed. Do you want to remove it? (y/n) ${NC}"
                        read response
                        if [ "$response" == "y" ]; then
                            rm "$file1"
                            printf "${GREEN}File removed:${NC} ${file1}\n"
                            file1_removed=true
                        else
                            printf "${RED}File not removed:${NC} ${file1}\n"
                            exit 1
                        fi
                    else
                        printf "${GREEN}File does not exist which is correct:${NC} ${file1}\n"
                        # Mark as removed if it did not exist to account for this in the final message
                        file1_removed=true
                    fi

                    # Check if the second file exists
                    if [ -e "$file2" ]; then
                        printf "${YELLOW}File exists:${NC} ${file2}\n"
                        # Use printf to correctly handle colors with read
                        printf "${YELLOW}For first launch of Fallout London it should be removed. Do you want to remove it? (y/n) ${NC}"
                        read response
                        if [ "$response" == "y" ]; then
                            rm "$file2"
                            printf "${GREEN}File removed:${NC} ${file2}\n"
                            file2_removed=true
                        else
                            printf "${RED}File not removed:${NC} ${file2}\n"
                            exit 1
                        fi
                    else
                        printf "${GREEN}File does not exist which is correct:${NC} ${file2}\n"
                        # Mark as removed if it did not exist to account for this in the final message
                        file2_removed=true
                    fi

			# Define the folder location
			FOLDER_LOCATION="$heroic_f4_path/Data"

			# Check for files starting with cc in the folder
			FILES=$(find "$FOLDER_LOCATION" -name 'cc*' 2>/dev/null)

			if [ -n "$FILES" ]; then
			    # Files found, prompt the user
				printf "${YELLOW}Creation Club items are recognized to be installed for Fallout 4. Those files should be removed to ensure Fallout London runs properly. Do you want to remove them? (y/n)${NC}\n"
			    read response
			    
			    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
				# User wants to remove the files
				rm -f "${FOLDER_LOCATION}/cc"*
				printf "${GREEN}Creation Club files have been removed.${NC}\n"
			    else
				# User does not want to remove the files
				printf "${RED}Creation Club files are present in Fallout 4 directory. Configuration incorrect.${NC}\n"
				exit 1
			    fi
			else
			    # No files found
			    printf "${GREEN}No Creation Club items are installed.${NC}\n"
			fi

                    # Define the path for Buffout Mod files
                    BUFFOUT_FOLDER="$heroic_f4_path/Data/F4SE/Plugins/Buffout4"
                    BUFFOUT_DLL="$heroic_f4_path/Data/F4SE/Plugins/Buffout4.dll"
                    BUFFOUT_PRELOAD="$heroic_f4_path/Data/F4SE/Plugins/Buffout4_preload.txt"

                    # Check if the Buffout Mod folder and files exist
                    if [ -d "$BUFFOUT_FOLDER" ] && [ -f "$BUFFOUT_DLL" ] && [ -f "$BUFFOUT_PRELOAD" ]; then
                        all_prerequisites_met=true
                        printf "${GREEN}'Buffout 4' Mod is recognized to be installed.${NC}\n"
                    else
                        printf "${RED}Buffout Mod is not installed. You may experience crashes during the Gameplay of Fallout London.${NC}\n"

				# Ask the user if they want to perform assisted installation
				printf "${YELLOW}Do you want to perform assisted installation of 'Buffout 4' mod with this script? (y/n)${NC}\n"

				# Read user input
				read -r user_input

				# Check the user input
				if [ "$user_input" == "n" ]; then
				    printf "${RED}'Buffout 4' mod is not installed${NC}\n"
				elif [ "$user_input" == "y" ]; then
				    printf "${YELLOW}1. Please download 'Buffout 4' mod from nexus (https://www.nexusmods.com/fallout4/mods/47359) \n2. Drag and drop the downloaded zip file on this window\n3. press enter.${NC}\n"
				    
				    # Read the full path of the dropped file
				    read -r dropped_file
				    
				        # Remove single quotes and replace with double quotes
					dropped_file="${dropped_file//\'/}"
				    # Check if the file exists
				    if [ -f "$dropped_file" ]; then
					printf "${GREEN}File dropped: ${dropped_file}${NC}\n"
					
					# Define the target directory
						target_dir="$heroic_f4_path/Data"

						# Unzip the file to the target directory
						unzip -o "$dropped_file" -d "$target_dir"

						# Check if the unzip command was successful
						if [ $? -eq 0 ]; then
						    printf "${GREEN}Successfully unzipped '$dropped_file' to '$target_dir'.${NC}\n"
						    
						    if [ -d "$BUFFOUT_FOLDER" ] && [ -f "$BUFFOUT_DLL" ] && [ -f "$BUFFOUT_PRELOAD" ]; then
							all_prerequisites_met=true
							printf "${GREEN}'Buffout 4' Mod is recognized to be installed.${NC}\n"
						    else
							printf "${RED}'Buffout 4' installation failed. Please try again or install it manually.${NC}\n"
							exit 1
						    fi
						    
						else
						    printf "${RED}Error: Failed to install 'Buffout 4' from file '$dropped_file'.${NC}\n"
						    exit 1
						fi
				    else
					printf "${RED}The dropped file does not exist. Please run the script again.${NC}\n"
					exit 1
				    fi
				else
				    printf "${RED}Invalid input. Please respond with 'y' or 'n'.${NC}\n"
				    exit 1
				fi


                    fi

			# Path to the config file
			config_file="$heroic_f4_path/Data/F4SE/Plugins/Buffout4/config.toml"

			# Check if the config file exists
			if [[ -f "$config_file" ]]; then
			    # Read the current value of MemoryManager
			    memory_manager_value=$(grep -E '^MemoryManager = (true|false)' "$config_file" | awk '{print $3}')

			    if [[ "$memory_manager_value" == "true" ]]; then
				# Prompt the user
				
			printf "${YELLOW}'(Optional step) 'Buffout 4' Mod currently replaces Fallout London's Memory Manager. It is recommended to disable this feature of 'Buffout 4'. Do you want to disable it? (y/n)${NC}\n"
				
				read user_input
				if [[ "$user_input" == "y" || "$user_input" == "Y" ]]; then
				    # Change the line to MemoryManager = false
				    sed -i 's/^MemoryManager = true/MemoryManager = false/' "$config_file"
				    printf "${GREEN}MemoryManager has been disabled in the 'Buffout 4' config.${NC}\n"
				else
				    printf "${RED}No changes were made to the 'Buffout 4' config.${NC}\n"
				fi
			    elif [[ "$memory_manager_value" == "false" ]]; then
				 printf "${GREEN}MemoryManager has been disabled in the 'Buffout 4' config.${NC}\n"
			    else
				printf "${RED}The MemoryManager setting was not found or is not set to true/false.${NC}\n"
			    fi
			else
			    printf "${RED}Config file not found: $config_file${NC}\n"
			fi

                    # Display the final message if all prerequisites are met
                    if [ "$all_prerequisites_met" = true ]; then
                        printf "${GREEN}Fallout London should be ready to run from Heroic Launcher's Fallout London page.${NC}\n"
                    fi


elif [ "$platform" == "s" ]; then
    printf "${GREEN}Steam Selected${NC}\n"

# Check where Steam Version of Fallout 4 is installed.
if [ -e "$SSD_F4_LAUNCHER_FILE" ]; then
    echo "Fallout 4 recognized to be installed on Internal SSD"

	STEAM_APPMANIFEST_PATH="$HOME/.local/share/Steam/steamapps/appmanifest_377160.acf"
	steam_f4_path="$HOME/.steam/steam/steamapps/common/Fallout 4"

elif [ -e "$SD_CARD_F4_LAUNCHER_FILE" ]; then
    echo "Fallout 4 recognized to be installed on SD Card"

        STEAM_APPMANIFEST_PATH="/run/media/mmcblk0p1/steamapps/appmanifest_377160.acf"
        steam_f4_path="/run/media/mmcblk0p1/steamapps/common/Fallout 4"

else
    echo "ERROR: Steam version of Fallout 4 is not installed on this device."
fi
    
    	fallout4defaultlauncher="75065f52666b9a2f3a76d9e85a66c182394bfbaa8e85e407b1a936adec3654cc"
    	fallout4defaultlauncher_check=$(sha256sum "$steam_f4_path/Fallout4Launcher.exe" | awk '{print $1}')
    	
    	if [ "$fallout4defaultlauncher" == "$fallout4defaultlauncher_check" ]; then
    		    printf "${RED}You are using standard Fallout 4 launcher exe. Your Game is not downgraded.${NC}\n"
    		    exit 1
    	else
    		printf "${GREEN}Correct. Game does not launch with standard launcher${NC}\n"
    	fi
    	

fallout4defaultlauncher_downg="5e457259dca72c8d1217e2f08a981b630ffd5fe0d30bf28269c8b7898491c6ae"
correct_launcher_sha="f41d4065a1da80d4490be0baeee91985d2b10b3746ec708b91dc82a64ec1e2a6"
fallout4defaultlauncher_downg_check=$(sha256sum "$steam_f4_path/Fallout4Launcher.exe" | awk '{print $1}')

if [ "$fallout4defaultlauncher_downg" == "$fallout4defaultlauncher_downg_check" ]; then
    printf "${RED}You are using a downgraded standard Fallout 4 launcher exe.${NC}\n"

    launcher_dir="$steam_f4_path"
    launcher_file="$launcher_dir/Fallout4Launcher.exe"
    f4se_loader_file="$launcher_dir/f4se_loader.exe"
    launcher_old_file="$launcher_dir/Fallout4Launcher.exe.old"
    custom_exit="N"

    # Check if Fallout4Launcher.exe and Fallout4Launcher.exe.old exist
    if [ -f "$launcher_file" ] && [ -f "$launcher_old_file" ]; then
        launcher_check=$(sha256sum "$launcher_file" | awk '{print $1}')
        if [ "$launcher_check" == "$correct_launcher_sha" ]; then
            printf "${GREEN}Launcher correctly renamed.${NC}\n"
        fi
    fi

    # Check if f4se_loader.exe and downgraded Fallout4Launcher.exe exist
    if [ -f "$f4se_loader_file" ] && [ "$fallout4defaultlauncher_downg_check" == "$fallout4defaultlauncher_downg" ]; then
        printf "${YELLOW}Both f4se_loader.exe and downgraded Fallout4Launcher.exe found. Do you want to rename the files to always run Fallout 4 using f4se_loader.exe? (y/n) ${NC}"
        read user_input
        if [ "$user_input" == "y" ] || [ "$user_input" == "Y" ]; then
            mv "$launcher_file" "$launcher_old_file"
            mv "$f4se_loader_file" "$launcher_file"
            printf "${GREEN}Files have been renamed.${NC}\n"
        else
            printf "${RED}Files were not renamed.${NC}\n"
        fi
    else
        printf "${RED}Fallout London is not installed or installation was not successful. Please ensure steps 9 and 10 from the instructions of Steam version of the game were completed successfully.${NC}"
        custom_exit="Y"
    fi
    
    if [ "$custom_exit" == "Y" ]; then
    exit 1
    fi
else
    printf "${GREEN}Correct. Game does not launch with standard downgraded launcher${NC}\n"
fi
    	
    launcher_dir="$steam_f4_path"
    launcher_file="$launcher_dir/Fallout4Launcher.exe"
    launcher_check=$(sha256sum "$launcher_file" | awk '{print $1}')

    # Check if the launcher sha is correct
    if [ "$launcher_check" == "$correct_launcher_sha" ]; then
        printf "${GREEN}f4se_loader.exe is correctly selected to run the game.${NC}\n"
        
    else
        printf "${RED}f4se_loader.exe was not renamed to Fallout4Launcher.exe.${NC}\n"
        exit 1
    fi
    	

            # Define the given checksum
            given_checksum="82cfb36d003551ee5db7fb3321e830e1bceed53aa74aa30bb49bf0278612a9d7"

            # Define the file path
            file_path="$steam_f4_steamuser/Documents/My Games/Fallout4/Fallout4.INI"



            # Compute the SHA-256 checksum of the file
            computed_checksum=$(sha256sum "$file_path" | awk '{ print $1 }')

            # Compare the computed checksum with the given checksum
            if [ "$computed_checksum" == "$given_checksum" ]; then
                printf "${GREEN}Fallout4.INI correctly placed${NC}\n"
                
            else
                printf "${RED}Fallout4.INI checksum does not match. Please make sure you put the file from: https://github.com/krupar101/f4london_steam_deck_ini/blob/main/Fallout4.INI inside '$file_path'.${NC}\n"

		fallout4_mygames_dir="$steam_f4_steamuser/Documents/My Games/Fallout4"

		# Check if the directory exists
		if [ -d "$fallout4_mygames_dir" ]; then
		    printf "${GREEN}'My Games' Fallout 4 directory exists${NC}\n"
		else
		    # Prompt the user to create the directory
		    printf "${YELLOW}\'My Games\' Fallout 4 directory does not exist. Do you want to create the missing directory $fallout4_mygames_dir? (y/n)${NC}\n"
		    read response
		    if [[ "$response" == "y" || "$response" == "Y" ]]; then
			mkdir -p "$fallout4_mygames_dir"
			printf "${GREEN}Directory $fallout4_mygames_dir created.${NC}\n"
		    else
			printf "${RED}Directory $fallout4_mygames_dir not created.${NC}\n"
			exit 1
		    fi
		fi

                
        printf "${YELLOW}Do you want to download the correct .INI file from GitHub automatically? (y/n) ${NC}\n"
        read -p "" user_input

		if [ "$user_input" == "y" ]; then
		    # Define the download URL and destination path
		    url="https://raw.githubusercontent.com/krupar101/f4london_steam_deck_ini/main/Fallout4.INI"
		    fallout4_mygames_dir="$steam_f4_steamuser/Documents/My Games/Fallout4"
		    destination="$fallout4_mygames_dir/Fallout4.INI"
		    
		    
		    
		    
            if [ -e "$steam_f4_steamuser/Documents/My Games/Fallout4/Fallout4.INI" ]; then
                rm "$steam_f4_steamuser/Documents/My Games/Fallout4/Fallout4.INI"
            fi

            if [ -e "$steam_f4_steamuser/Documents/My Games/Fallout4/Fallout4.ini" ]; then
                rm "$steam_f4_steamuser/Documents/My Games/Fallout4/Fallout4.ini"
            fi

		    # Download the file using wget
		    wget -O "$destination" "$url"
		    
		    # Check if the download was successful
		    if [ $? -eq 0 ]; then
                printf "${GREEN}File downloaded successfully to $destination${NC}\n"

		    else
			printf "${RED}Failed to download the file.${NC}\n"
			exit 1
		    fi
		else
		    echo "User exited the script"
		    exit 1
		fi

            fi

		# Define the directories and files
		TARGET_DIR="$steam_f4_steamuser/AppData/Local/Fallout4"
		BACKUP_DIR="$TARGET_DIR/backup"
		FALLOUT_DIR="$fallout_london_installer/__AppData"
		FILES=("DLCList.txt" "Plugins.fo4viewsettings" "Plugins.txt" "UserDownloadedContent.txt")

		# Check if the target directory exists
		if [ -d "$TARGET_DIR" ]; then
		    printf "${GREEN}AppData Directory Exists.${NC}\n"
		else
		    printf "${YELLOW}AppData Directory does not exist. Do you want to create it? (y/n): ${NC}"
		    read create_dir
		    if [ "$create_dir" = "y" ]; then
			mkdir -p "$TARGET_DIR"
			printf "${GREEN}Directory created.${NC}\n"
		    else
			printf "${RED}You exited the script. Configuration incorrect.${NC}\n"
			exit 1
		    fi
		fi

		# Check for the existence of the files
		missing_files=0
		for file in "${FILES[@]}"; do
		    if [ ! -f "$TARGET_DIR/$file" ]; then
			missing_files=1
			break
		    fi
		done

		if [ $missing_files -eq 1 ]; then
		    # Check if backup directory exists
		    if [ ! -d "$BACKUP_DIR" ]; then
			mkdir "$BACKUP_DIR"
			# Copy existing files to backup directory
			for file in "${FILES[@]}"; do
			    if [ -f "$TARGET_DIR/$file" ]; then
				cp "$TARGET_DIR/$file" "$BACKUP_DIR/"
			    fi
			done
		    fi

		    printf "${YELLOW}The AppData files are not correctly placed. Do you want to copy them over to Fallout 4 installation directory? (y/n): ${NC}"
		    read copy_files
		    if [ "$copy_files" = "y" ]; then
			files_exist=1
			for file in "${FILES[@]}"; do
			    if [ ! -f "$FALLOUT_DIR/$file" ]; then
				files_exist=0
				break
			    fi
			done

			if [ $files_exist -eq 1 ]; then
			    for file in "${FILES[@]}"; do
				cp "$FALLOUT_DIR/$file" "$TARGET_DIR/"
			    done
			    printf "${GREEN}AppData files copied.${NC}\n"
			else
			    printf "${RED}AppData files not present in Fallout 4 installation directory.${NC}\n"
			fi
		    else
			printf "${RED}You exited the script. Configuration incorrect.${NC}\n"
			exit 1
		    fi
		else
		    printf "${GREEN}All files are present in the AppData directory.${NC}\n"
		fi
		
		
                    # Define folder paths
                    FOLDER1="$steam_f4_path/Data/F4SE/plugins"
                    FOLDER2="$steam_f4_path/Data/F4SE/Plugins"


                    # Check if the "plugins" folder exists
                    if [ -d "$FOLDER1" ]; then
                        # Folder exists, prompt user to rename
                        printf "${YELLOW}It looks like you have a folder named 'plugins'. It is recommended to rename it to 'Plugins'.${NC}\n"
                        printf "${YELLOW}Do you want to rename it? (y/n) ${NC}"
                        read response

                        # Convert response to lowercase for case-insensitive comparison
                        response=$(echo "$response" | tr '[:upper:]' '[:lower:]')

                        if [ "$response" == "y" ]; then
                            # Rename the folder
                            mv "$FOLDER1" "$FOLDER2"
                            printf "${GREEN}Folder renamed to 'Plugins'.${NC}\n"
                        else
                            printf "${RED}Folder was not renamed.${NC}\n"
                        fi
                    
                    else
                        
                        if [ ! -d "$FOLDER1" ] && [ ! -d "$FOLDER2" ]; then
		                printf "${RED}Plugins folder does not exist under $FOLDER1. Fallout London mod might not be installed correctly.${NC}\n"
		            	exit 1
		        else
		        printf "${GREEN}Plugins folder exists.${NC}\n"
                    	fi
                    fi

                    # Define file paths
                    file1="$steam_f4_steamuser/Documents/My Games/Fallout4/Fallout4Custom.ini"
                    file2="$steam_f4_steamuser/Documents/My Games/Fallout4/Fallout4Prefs.ini"

                    # Initialize flags
                    file1_removed=false
                    file2_removed=false

                    # Check if the first file exists
                    if [ -e "$file1" ]; then
                        printf "${YELLOW}File exists:${NC} ${file1}\n"
                        # Use printf to correctly handle colors with read
                        printf "${YELLOW}For first launch of Fallout London it should be removed. Do you want to remove it? (y/n) ${NC}"
                        read response
                        if [ "$response" == "y" ]; then
                            rm "$file1"
                            printf "${GREEN}File removed:${NC} ${file1}\n"
                            file1_removed=true
                        else
                            printf "${RED}File not removed:${NC} ${file1}\n"
                            exit 1
                        fi
                    else
                        printf "${GREEN}File does not exist which is correct:${NC} ${file1}\n"
                        # Mark as removed if it did not exist to account for this in the final message
                        file1_removed=true
                    fi

                    # Check if the second file exists
                    if [ -e "$file2" ]; then
                        printf "${YELLOW}File exists:${NC} ${file2}\n"
                        # Use printf to correctly handle colors with read
                        printf "${YELLOW}For first launch of Fallout London it should be removed. Do you want to remove it? (y/n) ${NC}"
                        read response
                        if [ "$response" == "y" ]; then
                            rm "$file2"
                            printf "${GREEN}File removed:${NC} ${file2}\n"
                            file2_removed=true
                        else
                            printf "${RED}File not removed:${NC} ${file2}\n"
                            exit 1
                        fi
                    else
                        printf "${GREEN}File does not exist which is correct:${NC} ${file2}\n"
                        # Mark as removed if it did not exist to account for this in the final message
                        file2_removed=true
                    fi

			# Define the folder location
			FOLDER_LOCATION="$steam_f4_path/Data"

			# Check for files starting with cc in the folder
			FILES=$(find "$FOLDER_LOCATION" -name 'cc*' 2>/dev/null)

			if [ -n "$FILES" ]; then
			    # Files found, prompt the user
				printf "${YELLOW}Creation Club items are recognized to be installed for Fallout 4. Those files should be removed to ensure Fallout London runs properly. Do you want to remove them? (y/n)${NC}\n"
			    read response
			    
			    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
				# User wants to remove the files
				rm -f "${FOLDER_LOCATION}/cc"*
				printf "${GREEN}Creation Club files have been removed.${NC}\n"
			    else
				# User does not want to remove the files
				printf "${RED}Creation Club files are present in Fallout 4 directory. Configuration incorrect.${NC}\n"
				exit 1
			    fi
			else
			    # No files found
			    printf "${GREEN}No Creation Club items are installed.${NC}\n"
			fi

                    # Define the path for Buffout Mod files
                    BUFFOUT_FOLDER="$steam_f4_path/Data/F4SE/Plugins/Buffout4"
                    BUFFOUT_DLL="$steam_f4_path/Data/F4SE/Plugins/Buffout4.dll"
                    BUFFOUT_PRELOAD="$steam_f4_path/Data/F4SE/Plugins/Buffout4_preload.txt"

                    # Check if the Buffout Mod folder and files exist
                    if [ -d "$BUFFOUT_FOLDER" ] && [ -f "$BUFFOUT_DLL" ] && [ -f "$BUFFOUT_PRELOAD" ]; then
                        all_prerequisites_met=true
                        printf "${GREEN}'Buffout 4' Mod is recognized to be installed.${NC}\n"
                    else
                        printf "${RED}Buffout Mod is not installed. You may experience crashes during the Gameplay of Fallout London.${NC}\n"
                        
				# Ask the user if they want to perform assisted installation
				printf "${YELLOW}Do you want to perform assisted installation of 'Buffout 4' mod with this script? (y/n)${NC}\n"

				# Read user input
				read -r user_input

				# Check the user input
				if [ "$user_input" == "n" ]; then
				    printf "${RED}'Buffout 4' mod is not installed${NC}\n"
				elif [ "$user_input" == "y" ]; then
				    printf "${YELLOW}1. Please download 'Buffout 4' mod from nexus (https://www.nexusmods.com/fallout4/mods/47359) \n2. Drag and drop the downloaded zip file on this window\n3. press enter.${NC}\n"
				    
				    # Read the full path of the dropped file
				    read -r dropped_file
				    
				        # Remove single quotes and replace with double quotes
					dropped_file="${dropped_file//\'/}"
				    # Check if the file exists
				    if [ -f "$dropped_file" ]; then
					printf "${GREEN}File dropped: ${dropped_file}${NC}\n"
					
					# Define the target directory
						target_dir="$steam_f4_path/Data"

						# Unzip the file to the target directory
						unzip -o "$dropped_file" -d "$target_dir"

						# Check if the unzip command was successful
						if [ $? -eq 0 ]; then
						    printf "${GREEN}Successfully unzipped '$dropped_file' to '$target_dir'.${NC}\n"

						    if [ -d "$BUFFOUT_FOLDER" ] && [ -f "$BUFFOUT_DLL" ] && [ -f "$BUFFOUT_PRELOAD" ]; then
							all_prerequisites_met=true
							printf "${GREEN}'Buffout 4' Mod is recognized to be installed.${NC}\n"
						    else
							printf "${RED}'Buffout 4' installation failed. Please try again or install it manually.${NC}\n"
							exit 1
						    fi
						else
						    printf "${RED}Error: Failed to install 'Buffout 4' from file '$dropped_file'.${NC}\n"
						    exit 1
						fi
				    else
					printf "${RED}The dropped file does not exist. Please run the script again.${NC}\n"
					exit 1
				    fi
				else
				    printf "${RED}Invalid input. Please respond with 'y' or 'n'.${NC}\n"
				    exit 1
				fi
                    fi

			# Path to the config file
			config_file="$steam_f4_path/Data/F4SE/Plugins/Buffout4/config.toml"

			# Check if the config file exists
			if [[ -f "$config_file" ]]; then
			    # Read the current value of MemoryManager
			    memory_manager_value=$(grep -E '^MemoryManager = (true|false)' "$config_file" | awk '{print $3}')

			    if [[ "$memory_manager_value" == "true" ]]; then
				# Prompt the user
				
			printf "${YELLOW}'(Optional step) 'Buffout 4' Mod currently replaces Fallout London's Memory Manager. It is recommended to disable this feature of 'Buffout 4'. Do you want to disable it? (y/n)${NC}\n"
				
				read user_input
				if [[ "$user_input" == "y" || "$user_input" == "Y" ]]; then
				    # Change the line to MemoryManager = false
				    sed -i 's/^MemoryManager = true/MemoryManager = false/' "$config_file"
				    printf "${GREEN}MemoryManager has been disabled in the 'Buffout 4' config.${NC}\n"
				else
				    printf "${RED}No changes were made to the 'Buffout 4' config.${NC}\n"
				fi
			    elif [[ "$memory_manager_value" == "false" ]]; then
				 printf "${GREEN}MemoryManager has been disabled in the 'Buffout 4' config.${NC}\n"
			    else
				printf "${RED}The MemoryManager setting was not found or is not set to true/false.${NC}\n"
			    fi
			else
			    printf "${RED}Config file not found: $config_file${NC}\n"
			fi



FILE="$STEAM_APPMANIFEST_PATH"

display_f4update_escape_message() {
printf "${RED}You decided not to disable automatic updates for Fallout 4. The game may still be automatically updated through Steam which can break the Fallout London installation.${NC}\n"
}

# Check if the file exists first
if [ -e "$FILE" ]; then
	# Get the attributes of the file
	attributes=$(lsattr "$FILE" 2>/dev/null | awk '{print $1}')

	# Check if the immutable attribute 'i' is set
	if [[ $attributes == *i* ]]; then
		printf "${GREEN}Automatic updates for Steam version of Fallout 4 are disabled. \n\n${RED}If you ever want to re-enable automatic updates for Fallout 4, run this command in konsole:\nsudo chattr -i \"$FILE\"${NC}\n\n"
	else

		printf "${YELLOW}(Optional Step) Automatic updates for Steam version of Fallout 4 are enabled. Do you want to disable Steam automatic updates for Fallout 4? \n\n- THIS ACTION IS PERMANENT AND WILL REQUIRE YOU TO RUN A COMMAND IN CONSOLE TO REVERT IT BACK!\n- THIS COMMAND REQUIRES SUPER USER (SUDO) PRIVILEGES.\n- YOU WILL NEED TO PROVIDE SUDO PASSWORD TO PERFORM THIS STEP. (y/n)${NC}\n"

		# Read user response
		read response

		# Convert response to lowercase
		response=$(echo "$response" | tr '[:upper:]' '[:lower:]')

		if [[ "$response" == "y" ]]; then

			# Prompt the user with the question
			printf "${YELLOW}If you don't know what you're doing it's recommended not to perform this action. \nAre you sure you want to continue? (y/n)${NC}\n"

			# Read the user's response
			read response

			# Evaluate the response
			if [ "$response" = "y" ] || [ "$response" = "Y" ]; then

				# Get the password status for the current user
				PASS_STATUS=$(passwd -S $USER 2>/dev/null)

				# Extract the status field from the output
				STATUS=${PASS_STATUS:${#USER}+1:2}

				password_set="N"

				if [ "$STATUS" = "NP" ]; then

					printf "${RED}PASSWORD NOT SET${NC}\n"

					# Prompt the user with the question
					printf "${YELLOW}It looks like you don't have a SUDO password set for $USER user. Do you want to set it right now? (y/n)${NC}\n"

					# Read the user's response
					read response

					# Evaluate the response
					if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
						passwd
						password_set="Y"
						printf "${GREEN}SUDO Password is set for the user $USER${NC}\n"
					elif [ "$response" = "n" ] || [ "$response" = "N" ]; then
						display_f4update_escape_message
					else
						printf "${RED}Invalid response. Please enter 'y' or 'n'.${NC}\n"
					fi

				else
					printf "${GREEN}SUDO Password is set for the user $USER.${NC}\n"
					password_set="Y"
				fi

			elif
				[ "$response" = "n" ] || [ "$response" = "N" ]
			then
				display_f4update_escape_message
			else
				printf "${RED}Invalid response. Please enter y or n.${NC}\n"
			fi

			if [ "$password_set" = "Y" ]; then
				printf "\n${YELLOW}Please provide your password to disable Steam Automatic Updates for Fallout 4.${NC}\n"
				sudo chattr +i "$FILE"
				printf "${GREEN}Automatic updates for Steam version of Fallout 4 are disabled. \n\n${RED}If you ever want to re-enable automatic updates for Fallout 4, run this command in konsole:\nsudo chattr -i \"$FILE\"${NC}\n\n"
			fi

		elif
			[[ "$response" == "n" ]]
		then
			display_f4update_escape_message
		else
			printf "${RED}Invalid response. Please enter 'y' or 'n'. Please run the script again.${NC}\n"
			exit 1
		fi

	fi

else

	printf "${RED}file $file does not exist.${NC}\n"

fi



                    # Display the final message if all prerequisites are met
                    if [ "$all_prerequisites_met" = true ]; then
                        printf "${GREEN}Fallout London should be ready to run from the Steam Fallout 4 Page.${NC}\n"
                    fi



else
    printf "${RED}Invalid choice. Please enter 'g' for GoG or 's' for Steam.${NC}\n"
fi
