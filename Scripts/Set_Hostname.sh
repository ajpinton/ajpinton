#!/bin/bash
#*=============================================================================
#* Created: 
#* Author: 
#*=============================================================================
#* Purpose: Alert Users of name name change and allow them to perform changes.
#*=============================================================================
#* REVISION HISTORY
#*=============================================================================
#* Date: 
#* Author: 
#* Issue: 
#* Solution:
#*=============================================================================
#* SCRIPT NOTES
#*=============================================================================
#* This user alert script should be paired with the (package to deploy image assets)
#* package available in JAMF in order to polpulate the Regions icons used in
#* the script. Set this script to run after the icons have installed.
#*=============================================================================
#* VARIABLES
#*=============================================================================
serialnumber=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
windowType="utility"
## utility: creates an Apple "Utility" style window. Persisten message that has requires an action. [RECOMENDED]
## hud: creates an Apple "Heads Up Display" style window. Simple alert window, which can return false feedback if computer is locked.
## fs: creates a full screen window the restricts all user input. Remote access must be used to unlock machines in this mode.

icon="/path/to/image/assets.png"
title="Computer Name Change"
alignDescription="left" 
alignHeading="center"
timeout="0" ## Set desired timeout time in secconds
description="Due to new hardware naming standards, your computer will need to be renamed to match your serial number: $serialnumber

" ## Write message here
button1="Postpone"
button2="Rename"
defaultButton="0"
cancelButton="2"
#*=============================================================================
#* MAIN SCRIPT
#*=============================================================================
## Ensure Assets are installed
if [ ! -e "$icon" ]  
then
    sudo jamf policy -event installAlertIcons ## If it doesn't exits, download Assets
fi

## Present user alert
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
userChoice=$("$jamfHelper" -windowType "$windowType" -lockHUD -title "$title" -timeout "$timeout" -defaultButton "$defaultButton" -cancelButton "$cancelButton" -icon "$icon" -description "$description" -alignDescription "$alignDescription" -alignHeading "$alignHeading" -button1 "$button1" -button2 "$button2")

if [ "$userChoice" == "0" ]
then
	echo "User clicked on $button1"
elif [ "$userChoice" == "2" ]
then
	echo "User clicked on $button2"
	sudo jamf policy -event alias 2> /dev/null
	sudo jamf policy -event notificationChangeReboot
	exit 0    
fi