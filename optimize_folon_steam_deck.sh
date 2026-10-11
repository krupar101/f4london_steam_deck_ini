#!/usr/bin/env bash
# Fallout: London (Rabbit & Pork / 1.03+) Steam Deck optimization presets.
# Based on krupar's original Optimized / Medium / Potato archives.
# This script deliberately never replaces FOLON's bundled HighFPSPhysicsFix.dll.

set -euo pipefail

printf '%s\n' '---------------------' \
    'Fallout London optimization script for Steam Deck by krupar' \
    'https://ko-fi.com/krupar' '---------------------'

error() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
for cmd in zenity jq curl unzip awk mktemp; do
    command -v "$cmd" >/dev/null 2>&1 || error "Required tool not found: $cmd"
done

HEROIC_CONFIG_FILE="$HOME/.var/app/com.heroicgameslauncher.hgl/config/heroic/gog_store/installed.json"
HEROIC_PREFIX_FILE="$HOME/.var/app/com.heroicgameslauncher.hgl/config/heroic/GamesConfig/1998527297.json"

# Use the same installation detection as the original script, with SD-card support.
if [[ -n "${FOLON_GAME_DIR_OVERRIDE:-}" && -n "${FOLON_STEAMUSER_DIR_OVERRIDE:-}" ]]; then
    FALLOUT_4_DIR="$FOLON_GAME_DIR_OVERRIDE"
    FALLOUT_4_STEAMUSER_DIR="$FOLON_STEAMUSER_DIR_OVERRIDE"
else
    selected=$(zenity --list --radiolist \
        --title='Fallout 4 version' --width=450 --height=250 \
        --text='Which version of Fallout 4 do you own?' \
        --column='Select' --column='Version' \
        TRUE 'Steam' FALSE 'GOG') || exit 0
    case "$selected" in
      GOG)
        F4_VERSION='GOG'
        [[ -f "$HEROIC_CONFIG_FILE" && -f "$HEROIC_PREFIX_FILE" ]] || error 'Heroic configuration not found.'
        FALLOUT_4_DIR=$(jq -er '[.installed[] | select(.install_path | strings | contains("Fallout 4")) | .install_path][0]' "$HEROIC_CONFIG_FILE") || error 'Fallout 4 is not installed in Heroic.'
        prefix=$(jq -er '."1998527297".winePrefix' "$HEROIC_PREFIX_FILE") || error 'Heroic Fallout 4 prefix not found.'
        FALLOUT_4_STEAMUSER_DIR="$prefix/pfx/drive_c/users/steamuser"
      ;;
      Steam)
        F4_VERSION='STEAM'
        mount=$(findmnt -rn -o TARGET 2>/dev/null | grep -F '/run/media/' | head -n 1 || true)
        if [[ -f "$HOME/.steam/steam/steamapps/common/Fallout 4/Fallout4Launcher.exe" ]]; then
            FALLOUT_4_DIR="$HOME/.steam/steam/steamapps/common/Fallout 4"
        elif [[ -n "$mount" && -f "$mount/steamapps/common/Fallout 4/Fallout4Launcher.exe" ]]; then
            FALLOUT_4_DIR="$mount/steamapps/common/Fallout 4"
        else
            error 'Steam Fallout 4 installation not found.'
        fi
        compat="$HOME/.steam/steam/steamapps/compatdata/377160"
        if [[ ! -d "$compat/pfx" && -n "$mount" && -d "$mount/steamapps/compatdata/377160/pfx" ]]; then
            compat="$mount/steamapps/compatdata/377160"
        fi
        FALLOUT_4_STEAMUSER_DIR="$compat/pfx/drive_c/users/steamuser"
      ;;
      *) error 'No Fallout 4 version was selected.' ;;
    esac
fi

[[ -d "$FALLOUT_4_DIR/Data" ]] || error "Fallout 4 Data folder not found: $FALLOUT_4_DIR"
[[ -d "$FALLOUT_4_STEAMUSER_DIR" ]] || error "Wine/Proton user directory not found: $FALLOUT_4_STEAMUSER_DIR"

upper="$FALLOUT_4_DIR/Data/F4SE/Plugins"
lower="$FALLOUT_4_DIR/Data/F4SE/plugins"
if [[ -d "$upper" && -d "$lower" ]]; then
    error "Both 'Plugins' and 'plugins' directories exist. Resolve this manually to avoid editing the wrong one."
elif [[ -d "$upper" ]]; then
    fallout4_f4se_dir="$upper"
elif [[ -d "$lower" ]]; then
    fallout4_f4se_dir="$lower"
else
    error 'Data/F4SE/Plugins folder is missing. Install/update Fallout: London first.'
fi

# The DLL must be the version installed by Team FOLON. Never download/overwrite it.
[[ -f "$fallout4_f4se_dir/HighFPSPhysicsFix.dll" ]] || error 'Bundled HighFPSPhysicsFix.dll is missing. Repair the Fallout: London installation.'

fallout4_appdata_dir="$FALLOUT_4_STEAMUSER_DIR/AppData/Local/Fallout4"
fallout4_mygames_dir="$FALLOUT_4_STEAMUSER_DIR/Documents/My Games/Fallout4"
fallout4_data_dir="$FALLOUT_4_DIR/Data"
plugins_txt="$fallout4_appdata_dir/Plugins.txt"
[[ -f "$plugins_txt" ]] || error "Current Plugins.txt does not exist: $plugins_txt"

response=$(zenity --list --radiolist \
    --title='Fallout London Preset Selector' \
    --text="Select your tested Steam Deck preset.\n\nThe official High FPS DLL will be preserved.\nThe No_Shadow_Lights.esp optimization will be enabled.\n\nInstallation: $FALLOUT_4_DIR" \
    --column='Select' --column='Preset' \
    TRUE 'Optimized (Recommended)' \
    FALSE 'Medium' \
    FALSE 'Potato' \
    --width=530 --height=395) || exit 0

case "$response" in
    'Optimized (Recommended)') LINK_PREFIX='' ;;
    'Medium') LINK_PREFIX='medium_' ;;
    'Potato') LINK_PREFIX='potato_' ;;
    *) error 'No preset selected.' ;;
esac

PRESET_FILENAME="${LINK_PREFIX}folon_steam_deck_optimization.zip"
TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/folon_optimization.XXXXXXXX") || error 'Unable to create temporary directory.'
trap 'rm -rf -- "$TEMP_DIR"' EXIT

if [[ -n "${FOLON_PRESET_ZIP_DIR:-}" ]]; then
    [[ -f "$FOLON_PRESET_ZIP_DIR/$PRESET_FILENAME" ]] || error "Preset not found: $FOLON_PRESET_ZIP_DIR/$PRESET_FILENAME"
    cp "$FOLON_PRESET_ZIP_DIR/$PRESET_FILENAME" "$TEMP_DIR/preset.zip"
else
    ZIP_URL="https://raw.githubusercontent.com/krupar101/f4london_steam_deck_ini/refs/heads/main/$PRESET_FILENAME"
    echo "Downloading $ZIP_URL"
    curl -fLSs --retry 2 -o "$TEMP_DIR/preset.zip" "$ZIP_URL" || error 'Failed to download preset archive.'
fi
unzip -tq "$TEMP_DIR/preset.zip" >/dev/null || error 'Preset ZIP is corrupted.'
unzip -q "$TEMP_DIR/preset.zip" -d "$TEMP_DIR/outer"

# Updated ZIP layout contains only 3 inner archives; no Plugins.txt or DLL.
for inner in documents_ini_folon.zip f4se_plugins_folon.zip f4_data_folon.zip; do
    [[ -f "$TEMP_DIR/outer/$inner" ]] || error "Missing preset component: $inner. Upload the updated ZIPs to GitHub first."
    unzip -tq "$TEMP_DIR/outer/$inner" >/dev/null || error "Corrupt inner ZIP: $inner"
done
mkdir -p "$TEMP_DIR/docs" "$TEMP_DIR/f4se" "$TEMP_DIR/data"
unzip -q "$TEMP_DIR/outer/documents_ini_folon.zip" -d "$TEMP_DIR/docs"
unzip -q "$TEMP_DIR/outer/f4se_plugins_folon.zip" -d "$TEMP_DIR/f4se"
unzip -q "$TEMP_DIR/outer/f4_data_folon.zip" -d "$TEMP_DIR/data"

for file in "$TEMP_DIR/docs/Fallout4.INI" "$TEMP_DIR/docs/Fallout4Prefs.ini" \
    "$TEMP_DIR/f4se/HighFPSPhysicsFix.ini" "$TEMP_DIR/data/No_Shadow_Lights.esp"; do
    [[ -s "$file" ]] || error "Missing or empty preset file: $file"
done
if find "$TEMP_DIR" -type f -iname 'HighFPSPhysicsFix.dll' | grep -q .; then
    error 'Refusing to apply preset: it contains a separate HighFPSPhysicsFix.dll.'
fi

# Preserve the files currently on the Steam Deck before installing the preset.
backup_root="$HOME/Downloads/folon_optimization_backups"
mkdir -p "$backup_root"
BACKUP_DIR=$(mktemp -d "$backup_root/backup.XXXXXXXX") || error 'Unable to create backup.'
backup_file() {
    local src="$1" group="$2"
    if [[ -f "$src" ]]; then
        mkdir -p "$BACKUP_DIR/$group"
        cp -p -- "$src" "$BACKUP_DIR/$group/" || error "Failed to back up: $src"
    fi
}

backup_file "$fallout4_mygames_dir/Fallout4.INI" documents
backup_file "$fallout4_mygames_dir/Fallout4.ini" documents
backup_file "$fallout4_mygames_dir/Fallout4Prefs.ini" documents
backup_file "$fallout4_f4se_dir/HighFPSPhysicsFix.ini" f4se
backup_file "$fallout4_data_dir/No_Shadow_Lights.esp" data
backup_file "$plugins_txt" appdata

# Keep your preset's original, tested Fallout4.INI intact.
mkdir -p "$fallout4_mygames_dir"
rm -f -- "$fallout4_mygames_dir/Fallout4.ini"
cp -- "$TEMP_DIR/docs/Fallout4.INI" "$fallout4_mygames_dir/Fallout4.INI"
cp -- "$TEMP_DIR/docs/Fallout4Prefs.ini" "$fallout4_mygames_dir/Fallout4Prefs.ini"

# Includes original Steam Deck tuning, five 1.03 keys, AllowTearing=true,
# and FontFile=droidsans.font. Do not replace the corresponding DLL.
cp -- "$TEMP_DIR/f4se/HighFPSPhysicsFix.ini" "$fallout4_f4se_dir/HighFPSPhysicsFix.ini"

# Keep the existing No Shadow Lights tweak, and enable it WITHOUT replacing the
# official Plugins.txt or deleting other installed mods.
cp -- "$TEMP_DIR/data/No_Shadow_Lights.esp" "$fallout4_data_dir/No_Shadow_Lights.esp"
updated_list="$TEMP_DIR/Plugins.txt"
awk '
    {
        line=$0
        sub(/\r$/, "", line)
        low=tolower(line)
        if (low == "*no_shadow_lights.esp" || low == "no_shadow_lights.esp") next
        print line
    }
    END { print "*No_Shadow_Lights.esp" }
' "$plugins_txt" > "$updated_list"
cat "$updated_list" > "$plugins_txt"

printf '\nOptimization preset applied: %s\nBackups: %s\n' "$response" "$BACKUP_DIR"
zenity --info --title='Fallout London optimization' --width=500 \
    --text="Optimization applied: $response\n\nExisting bundled DLLs were preserved.\nBackup directory:\n$BACKUP_DIR" 2>/dev/null || true
