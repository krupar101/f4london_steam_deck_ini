#!/bin/bash

FILES=(
"$HOME/Games/Heroic/Prefixes/default/Fallout 4 Game of the Year Edition/pfx/drive_c/users/steamuser/Documents/My Games/Fallout4/Fallout4.INI"
"$HOME/Games/Heroic/Prefixes/default/Fallout 4 Game of the Year Edition/pfx/drive_c/users/steamuser/Documents/My Games/Fallout4/Fallout4Prefs.INI"
)

if [[ "$1" == "lock" ]]; then
    ACTION="+i"
    MSG="Locking (making immutable)"
    FINAL_MSG="Both files are now locked (immutable)."
elif [[ "$1" == "unlock" ]]; then
    ACTION="-i"
    MSG="Unlocking (making changeable)"
    FINAL_MSG="Both files are now unlocked (changeable)."
else
    echo "Usage: $0 [lock|unlock]"
    exit 1
fi

for FILE in "${FILES[@]}"; do
    if [ ! -f "$FILE" ]; then
        echo "File not found: $FILE"
        continue
    fi
    echo "$MSG $FILE"
    sudo chattr $ACTION "$FILE"
done

echo
echo "$FINAL_MSG"
