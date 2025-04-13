#!/bin/bash

#=============================================================================
# Script Name: Restore_Hot_Corners (Undo CIS L2 10.13)
# Created: [04/11/25]
# Author: Still fixing the same mistakes
#=============================================================================
# Purpose: Restores Disable Screen Saver (value 6) to all corners if needed
#=============================================================================

CURRENT_USER=$(/usr/sbin/scutil <<< "show State:/Users/ConsoleUser" | /usr/bin/awk '/Name :/ && ! /loginwindow/ { print $3 }')

if [[ -z "$CURRENT_USER" ]]; then
    echo "No user logged in. Cannot restore hot corners."
    exit 2
fi

USER_PREFS="/Users/$CURRENT_USER/Library/Preferences/com.apple.dock"

# Restore "Disable Screen Saver" to all corners for rollback/testing
for CORNER in tl tr bl br; do
    /usr/bin/sudo -u "$CURRENT_USER" /usr/bin/defaults write "$USER_PREFS" "wvous-${CORNER}-corner" -int 6
done

echo "Restored Disable Screen Saver (6) to all hot corners."
/usr/bin/sudo -u "$CURRENT_USER" /usr/bin/killall Dock
exit 0