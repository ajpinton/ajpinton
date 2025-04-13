#!/bin/bash

#*=============================================================================
#* Script Name: Show Known File Extension Status.sh
#* Created: [04/03/25]
#* Author: You, fixing other people's mistakes
#*=============================================================================
#* Purpose: Checks to see if the Active User has Show Known File Extensions Enabled and reports status
#*=============================================================================

# Get the currently logged-in user
CURRENT_USER=$(/usr/sbin/scutil <<< "show State:/Users/ConsoleUser" | /usr/bin/awk '/Name :/ && ! /loginwindow/ { print $3 }')

# Check if a user is logged in
if [ -z "$CURRENT_USER" ]; then
    # No user is logged in
    echo "<result>No User Logged In</result>"
else
    # Check if AppleShowAllExtensions is set to show extensions
    show_extensions=$(/usr/bin/sudo -u "$CURRENT_USER" /usr/bin/defaults read /Users/"$CURRENT_USER"/Library/Preferences/.GlobalPreferences AppleShowAllExtensions 2>/dev/null)

    # Determine compliance
    if [ "$show_extensions" == "1" ]; then
        echo "<result>Compliant</result>"
    else
        echo "<result>Not Compliant</result>"
    fi
fi
