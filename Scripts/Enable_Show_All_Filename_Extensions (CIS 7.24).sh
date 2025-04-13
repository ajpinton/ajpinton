#!/bin/bash

#*=============================================================================
#* Script Name: Enable_Show_All_Filename_Extensions (CIS 7.24).sh
#* Created: [04/03/25]
#* Author: You, fixing other people's mistakes
#*=============================================================================
#* Purpose: Checks to see if the Active User has Known File Extensions Shown
#* Purpose: Script will Enable Shown Known File Extensions if not enabled.
#* Purpose: If Show Known File Extensions is Enabled, Script will exit.
#* Purpose: If no user is logged in Script will fail and exit, this can be changed on line 29
#*=============================================================================

#*=============================================================================
#* Exit Codes
#*=============================================================================
#* 0 = Successful
#* 1 = Failed to Enable Show Known File Extensions
#* 2 = User Not Logged in, no action needed
#*=============================================================================

# Get the currently logged-in user
CURRENT_USER=$(/usr/sbin/scutil <<< "show State:/Users/ConsoleUser" | /usr/bin/awk '/Name :/ && ! /loginwindow/ { print $3 }')

# Check if a user is logged in
if [ -z "$CURRENT_USER" ]; then
    # No user is logged in, exit with status 2 and message
    echo "No user logged in, exiting."
    exit 2
fi

# Check if AppleShowAllExtensions is set to show extensions for the logged-in user
show_extensions=$(/usr/bin/sudo -u "$CURRENT_USER" /usr/bin/defaults read /Users/"$CURRENT_USER"/Library/Preferences/.GlobalPreferences AppleShowAllExtensions 2>/dev/null)

# If extensions are already shown, exit with status 0 and message
if [ "$show_extensions" == "1" ]; then
    echo "Known File Extensions Already Displayed"
    exit 0
fi

# Function to enable showing all filename extensions
enable_show_extensions() {
    /usr/bin/sudo -u "$CURRENT_USER" /usr/bin/defaults write /Users/"$CURRENT_USER"/Library/Preferences/.GlobalPreferences AppleShowAllExtensions -bool true
}

# Enable the setting to show filename extensions
enable_show_extensions

# Re-check if the setting was applied correctly
show_extensions_after=$( /usr/bin/sudo -u "$CURRENT_USER" /usr/bin/defaults read /Users/"$CURRENT_USER"/Library/Preferences/.GlobalPreferences AppleShowAllExtensions 2>/dev/null )

# If the setting is now correct, exit with status 0 and success message
if [ "$show_extensions_after" == "1" ]; then
    echo "Success"
    exit 0
else
    # If the setting is still not applied, exit with status 1 and failure message
    echo "Failed to enable Known File Extensions"
    exit 1
fi
