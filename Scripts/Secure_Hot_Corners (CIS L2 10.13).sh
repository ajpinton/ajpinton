#!/bin/bash

#=============================================================================
# Script Name: Secure_Hot_Corners (CIS L2 10.13)
# Created: [04/03/25]
# Author: You, fixing other people's mistakes
#=============================================================================
# Purpose: Removes Disable Screen Saver (value 6) from any hot corner
#=============================================================================
#=============================================================================
# Exit Codes:
#=============================================================================
# 0 = Successful
# 1 = Failed to remove insecure hot corners
# 2 = No user logged in
#=============================================================================
#=============================================================================
# Hot Corner Values
#=============================================================================
# Value Action
# 0 No Action
# 2 Mission Control
# 3 Application Windows
# 4 Desktop
# 5 Start Screen Saver
# 6 Disable Screen Saver - Finding
# 7 Dashboard (legacy)
# 10    Put Display to Sleep 
# 11    Launchpad
# 13    Notification Center
# 14    Quick Note
#=============================================================================

CURRENT_USER=$(/usr/sbin/scutil <<< "show State:/Users/ConsoleUser" | /usr/bin/awk '/Name :/ && ! /loginwindow/ { print $3 }')

# Exit if no user logged in
if [[ -z "$CURRENT_USER" ]]; then
    echo "No user logged in. Exiting."
    exit 2
fi

USER_PREFS="/Users/$CURRENT_USER/Library/Preferences/com.apple.dock"

# Map shorthand to full name
get_corner_name() {
    case "$1" in
        "tl") echo "Top Left" ;;
        "tr") echo "Top Right" ;;
        "bl") echo "Bottom Left" ;;
        "br") echo "Bottom Right" ;;
        *) echo "Unknown Corner" ;;
    esac
}

# Array of all four corners
CORNERS=("tl" "tr" "bl" "br")

# Flag for changes
CHANGED=false

for CORNER in "${CORNERS[@]}"; do
    VALUE=$(/usr/bin/defaults read "$USER_PREFS" "wvous-${CORNER}-corner" 2>/dev/null || echo 0)
    if [[ "$VALUE" -eq 6 ]]; then
        CORNER_NAME=$(get_corner_name "$CORNER")
        echo "$CORNER_NAME is set to Disable Screen Saver (6). Resetting to No Action (0)."
        /usr/bin/sudo -u "$CURRENT_USER" /usr/bin/defaults write "$USER_PREFS" "wvous-${CORNER}-corner" -int 0
        CHANGED=true
    fi
done

if $CHANGED; then
    echo "Changes made. Restarting Dock."
    /usr/bin/sudo -u "$CURRENT_USER" /usr/bin/killall Dock
    exit 0
else
    echo "No insecure Hot Corners detected."
    exit 0
fi
