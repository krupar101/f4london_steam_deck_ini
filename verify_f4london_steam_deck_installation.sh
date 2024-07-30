#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Prompt the user for the game version
printf "${YELLOW}Fallout London installation verification script for Steam Deck.\nWhich platform are you using? (g for GoG / s for Steam)${NC}\n"
read platform

# Initialize prerequisites flag
all_prerequisites_met=false

# Check the user's input and respond accordingly
if [ "$platform" == "g" ]; then
    printf "${GREEN}GoG Selected${NC}\n"

    # Capture the output of the command into a variable
    output=$(flatpak list | grep "com.heroicgameslauncher.hgl")

    # Set IFS to tab to split the string by tabs
    IFS=$'\t' read -r -a array <<< "$output"

    string1="${array[2]}"

    # Capture the output of the second command into a variable
	string2=$(LANG=en_US.UTF-8 flatpak remote-info flathub com.heroicgameslauncher.hgl | grep "Version:" | awk '{print $2}' || echo "")


if [[ "$string1" == "$string2" || -z "$string2" ]]; then
        printf "${GREEN}Heroic Launcher is up to date${NC}\n"

        # Define the path to the Heroic game configurations
        GAME_CONFIG_DIR="$HOME/.var/app/com.heroicgameslauncher.hgl/config/heroic/GamesConfig"

        # Define the name or identifier of your specific game
        GAME_NAME="1491728574"

        # Locate the game configuration file
        CONFIG_FILE="${GAME_CONFIG_DIR}/${GAME_NAME}.json"

        # Check if the configuration file exists
        if [ ! -f "$CONFIG_FILE" ]; then
            printf "${RED}Configuration file for $GAME_NAME not found.${NC}\n"
            exit 1
        fi

        # Extract the wineVersion.name from the configuration file
        WINE_VERSION_NAME=$(jq -r --arg game_id "$GAME_NAME" '.[$game_id].wineVersion.name' "$CONFIG_FILE")

        # Check if the WINE_VERSION_NAME matches the specified values
        if [ "$WINE_VERSION_NAME" == "Proton - Proton-GE-Proton9-10" ] || [ "$WINE_VERSION_NAME" == "Proton - Proton - Experimental" ]; then
            printf "${GREEN}Correct Proton version selected in Heroic Launcher: '$WINE_VERSION_NAME'${NC}\n"

            # Define the given checksum
            given_checksum="82cfb36d003551ee5db7fb3321e830e1bceed53aa74aa30bb49bf0278612a9d7"

            # Define the file path
            file_path="$HOME/Games/Heroic/Prefixes/default/Fallout London/pfx/drive_c/users/steamuser/Documents/My Games/Fallout4/Fallout4.INI"

            # Compute the SHA-256 checksum of the file
            computed_checksum=$(sha256sum "$file_path" | awk '{ print $1 }')

            # Compare the computed checksum with the given checksum
            if [ "$computed_checksum" == "$given_checksum" ]; then
                printf "${GREEN}Fallout4.INI correctly placed${NC}\n"

                # Define the path to the Proton prefix
                PROTONPREFIX="$HOME/Games/Heroic/Prefixes/default/Fallout London/pfx"

                # Define the path to the FAudio.dll file
                FAudio_FILE="$PROTONPREFIX/drive_c/windows/system32/FAudio.dll"

                # Check if the FAudio.dll file exists
                if [ -f "$FAudio_FILE" ]; then
                    printf "${GREEN}FAudio.dll is installed${NC}\n"  # Green for file found

                    # Define folder paths
                    FOLDER1="$HOME/Games/Heroic/Fallout 4 GOTY/Data/F4SE/plugins"
                    FOLDER2="$HOME/Games/Heroic/Fallout 4 GOTY/Data/F4SE/Plugins"

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
                    file1="$HOME/Games/Heroic/Prefixes/default/Fallout London/pfx/drive_c/users/steamuser/Documents/My Games/Fallout4/Fallout4Custom.ini"
                    file2="$HOME/Games/Heroic/Prefixes/default/Fallout London/pfx/drive_c/users/steamuser/Documents/My Games/Fallout4/Fallout4Prefs.ini"

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

                    # Define the path for Buffout Mod files
                    BUFFOUT_FOLDER="$HOME/Games/Heroic/Fallout 4 GOTY/Data/F4SE/Plugins/Buffout4"
                    BUFFOUT_DLL="$HOME/Games/Heroic/Fallout 4 GOTY/Data/F4SE/Plugins/Buffout4.dll"
                    BUFFOUT_PRELOAD="$HOME/Games/Heroic/Fallout 4 GOTY/Data/F4SE/Plugins/Buffout4_preload.txt"

                    # Check if the Buffout Mod folder and files exist
                    if [ -d "$BUFFOUT_FOLDER" ] && [ -f "$BUFFOUT_DLL" ] && [ -f "$BUFFOUT_PRELOAD" ]; then
                        all_prerequisites_met=true
                        printf "${GREEN}'Buffout 4' Mod is recognized to be installed.${NC}\n"
                    else
                        printf "${RED}Buffout Mod is not installed. You may experience crashes during the Gameplay of Fallout London.${NC}\n"
                    fi

                    # Display the final message if all prerequisites are met
                    if [ "$all_prerequisites_met" = true ]; then
                        printf "${GREEN}Fallout London should be ready to run from Heroic Launcher's Fallout London page.${NC}\n"
                    fi

                else
                    printf "${RED}FAudio.dll is not installed in the Proton prefix. Please refer to step 11 of the instructions on https://www.reddit.com/r/fallout4london/comments/1ebrc74/steam_deck_instructions/ for GoG Fallout London installation${NC}\n"  # Red for file not found
                fi

            else
                printf "${RED}Fallout4.INI checksum does not match. Please make sure you put the file from: https://github.com/krupar101/f4london_steam_deck_ini/blob/main/Fallout4.INI inside '$HOME/Games/Heroic/Prefixes/default/Fallout London/pfx/drive_c/users/steamuser/Documents/My Games/Fallout4/Fallout4.INI'.${NC}\n"
                exit 1
            fi

        else
            printf "${RED}Wrong Proton Version selected in Heroic Launcher '$WINE_VERSION_NAME'. Please select either 'Proton - Proton-GE-Proton9-10' or 'Proton - Proton - Experimental'.${NC}\n"
        fi

    else
        printf "${RED}Update Heroic Games Launcher from the discover store.${NC}\n"
    fi

elif [ "$platform" == "s" ]; then
    printf "${GREEN}Steam Selected${NC}\n"
    
    	fallout4defaultlauncher="75065f52666b9a2f3a76d9e85a66c182394bfbaa8e85e407b1a936adec3654cc"
    	fallout4defaultlauncher_check=$(sha256sum "$HOME/.steam/steam/steamapps/common/Fallout 4/Fallout4Launcher.exe" | awk '{print $1}')
    	
    	if [ "$fallout4defaultlauncher" == "$fallout4defaultlauncher_check" ]; then
    		    printf "${RED}You are using standard Fallout 4 launcher exe. Your Game is not downgraded.${NC}\n"
    		    exit 1
    	else
    		printf "${GREEN}Correct. Game does not launch with standard launcher${NC}\n"
    	fi
    	

fallout4defaultlauncher_downg="5e457259dca72c8d1217e2f08a981b630ffd5fe0d30bf28269c8b7898491c6ae"
correct_launcher_sha="f41d4065a1da80d4490be0baeee91985d2b10b3746ec708b91dc82a64ec1e2a6"
fallout4defaultlauncher_downg_check=$(sha256sum "$HOME/.steam/steam/steamapps/common/Fallout 4/Fallout4Launcher.exe" | awk '{print $1}')

if [ "$fallout4defaultlauncher_downg" == "$fallout4defaultlauncher_downg_check" ]; then
    printf "${RED}You are using a downgraded standard Fallout 4 launcher exe.${NC}\n"

    launcher_dir="$HOME/.steam/steam/steamapps/common/Fallout 4"
    launcher_file="$launcher_dir/Fallout4Launcher.exe"
    f4se_loader_file="$launcher_dir/f4se_loader.exe"
    launcher_old_file="$launcher_dir/Fallout4Launcher.exe.old"

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
        read -p "" user_input
        if [ "$user_input" == "y" ] || [ "$user_input" == "Y" ]; then
            mv "$launcher_file" "$launcher_old_file"
            mv "$f4se_loader_file" "$launcher_file"
            printf "${GREEN}Files have been renamed.${NC}\n"
        else
            printf "${RED}Files were not renamed.${NC}\n"
        fi
    fi

    exit 1
else
    printf "${GREEN}Correct. Game does not launch with standard downgraded launcher${NC}\n"

    launcher_dir="$HOME/.steam/steam/steamapps/common/Fallout 4"
    launcher_file="$launcher_dir/Fallout4Launcher.exe"
    launcher_check=$(sha256sum "$launcher_file" | awk '{print $1}')

    # Check if the launcher sha is correct
    if [ "$launcher_check" == "$correct_launcher_sha" ]; then
        printf "${GREEN}f4se_loader.exe is correctly selected to run the game.${NC}\n"
        
    else
        printf "${RED}f4se_loader.exe was not renamed to Fallout4Launcher.exe.${NC}\n"
        exit 1
    fi
fi
    	

            # Define the given checksum
            given_checksum="82cfb36d003551ee5db7fb3321e830e1bceed53aa74aa30bb49bf0278612a9d7"

            # Define the file path
            file_path="$HOME/.steam/steam/steamapps/compatdata/377160/pfx/drive_c/users/steamuser/Documents/My Games/Fallout4/Fallout4.INI"



            # Compute the SHA-256 checksum of the file
            computed_checksum=$(sha256sum "$file_path" | awk '{ print $1 }')

            # Compare the computed checksum with the given checksum
            if [ "$computed_checksum" == "$given_checksum" ]; then
                printf "${GREEN}Fallout4.INI correctly placed${NC}\n"
                
            else
                printf "${RED}Fallout4.INI checksum does not match. Please make sure you put the file from: https://github.com/krupar101/f4london_steam_deck_ini/blob/main/Fallout4.INI inside '$file_path'.${NC}\n"
               exit 1
            fi

		# Define the directories and files
		TARGET_DIR="$HOME/.steam/steam/steamapps/compatdata/377160/pfx/drive_c/users/steamuser/AppData/Local/Fallout4"
		BACKUP_DIR="$TARGET_DIR/backup"
		FALLOUT_DIR="$HOME/Games/Heroic/Fallout London/__AppData"
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
                    FOLDER1="$HOME/.steam/steam/steamapps/common/Fallout 4/Data/F4SE/plugins"
                    FOLDER2="$HOME/.steam/steam/steamapps/common/Fallout 4/Data/F4SE/Plugins"


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
                    file1="$HOME/.steam/steam/steamapps/compatdata/377160/pfx/drive_c/users/steamuser/Documents/My Games/Fallout4/Fallout4Custom.ini"
                    file2="$HOME/.steam/steam/steamapps/compatdata/377160/pfx/drive_c/users/steamuser/Documents/My Games/Fallout4/Fallout4Prefs.ini"

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

                    # Define the path for Buffout Mod files
                    BUFFOUT_FOLDER="$HOME/.steam/steam/steamapps/common/Fallout 4/Data/F4SE/Plugins/Buffout4"
                    BUFFOUT_DLL="$HOME/.steam/steam/steamapps/common/Fallout 4/Data/F4SE/Plugins/Buffout4.dll"
                    BUFFOUT_PRELOAD="$HOME/.steam/steam/steamapps/common/Fallout 4/Data/F4SE/Plugins/Buffout4_preload.txt"

                    # Check if the Buffout Mod folder and files exist
                    if [ -d "$BUFFOUT_FOLDER" ] && [ -f "$BUFFOUT_DLL" ] && [ -f "$BUFFOUT_PRELOAD" ]; then
                        all_prerequisites_met=true
                        printf "${GREEN}'Buffout 4' Mod is recognized to be installed.${NC}\n"
                    else
                        printf "${RED}Buffout Mod is not installed. You may experience crashes during the Gameplay of Fallout London.${NC}\n"
                    fi

                    # Display the final message if all prerequisites are met
                    if [ "$all_prerequisites_met" = true ]; then
                        printf "${GREEN}Fallout London should be ready to run from the Steam Fallout 4 Page.${NC}\n"
                    fi

else
    printf "${RED}Invalid choice. Please enter 'g' for GoG or 's' for Steam.${NC}\n"
fi
