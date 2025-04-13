#!/bin/bash

#=============================================================================
# Script Name: Disable_Show_All_Filename_Extensions (Rollback CIS 7.24)
# Created: [04/11/25]
# Author: Reverse gear specialist
#=============================================================================
# Purpose: Reverts the Show All Filename Extensions setting for the current user
#=============================================================================

# Get the currently logged-in user
CURRENT_USER=$(/usr/sbin/scutil <<< "show State:/Users/ConsoleUser" | /usr/bin/awk '/Name :/ && ! /loginwindow/ { print $3 }')

# Check if a user is logged in
if [ -z "$CURRENT_USER" ]; then
    echo "No user logged in. Nothing to revert."
    exit 2
fi

# Disable the show extensions setting
/usr/bin/sudo -u "$CURRENT_USER" /usr/bin/defaults write /Users/"$CURRENT_USER"/Library/Preferences/.GlobalPreferences AppleShowAllExtensions -bool false

# Validate the setting was removed
current_state=$(/usr/bin/sudo -u "$CURRENT_USER" /usr/bin/defaults read /Users/"$CURRENT_USER"/Library/Preferences/.GlobalPreferences AppleShowAllExtensions 2>/dev/null)

if [ "$current_state" == "0" ]; then
    echo "Successfully reverted 'Show All Extensions'"
    exit 0
else
    echo "Failed to revert setting"
    exit 1
fi
