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

# Display a Zenity list dialog with 5 options
choice=$(zenity --list \
  --title="Choose an Option" \
  --text="Select one of the following options:" \
  --column="No" --column="Description" \
  "1" "Install/Update Fallout London [LINUX]" \
  "2" "Optimize Fallout London [STEAM DECK]" \
  "3" "Clean Previous Fallout 4 Files and Mods from Fallout London Installation [ALL]" \
  "4" "Downgrade Steam Version of Fallout 4 [ALL]" \
  --width=580 --height=220)

# Check the user's choice
if [[ "$choice" == "1" ]]; then
  echo "Install/Update Fallout London [LINUX]"
  bash <(curl -s https://raw.githubusercontent.com/overkillwtf/folon-steamdeck-installer/main/fallout.sh)
elif [[ "$choice" == "2" ]]; then
  echo "Optimize Fallout London [STEAM DECK]"
  bash <(curl -s https://raw.githubusercontent.com/krupar101/f4london_steam_deck_ini/refs/heads/main/optimize_folon_steam_deck.sh)
elif [[ "$choice" == "3" ]]; then
  echo "Clean Previous Fallout 4 Files and Mods from Fallout London Installation [ALL]"
  bash <(curl -s https://raw.githubusercontent.com/krupar101/f4london_steam_deck_ini/refs/heads/main/f4london_remove_leftover_files.sh)
elif [[ "$choice" == "4" ]]; then
  echo "Downgrade Steam Version of Fallout 4 [ALL]"
  bash <(curl -s https://raw.githubusercontent.com/krupar101/f4london_steam_deck_ini/refs/heads/main/FOLON_Linux_Downgrader.sh)
else
  echo "No valid option selected or dialog was canceled."
fi

bash <(curl -s https://raw.githubusercontent.com/krupar101/f4london_steam_deck_ini/refs/heads/main/ultimate_folon_script.sh)
