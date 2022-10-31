#!/bin/bash
 
#!/usr/bin/env bash
#*=============================================================================
#* Script Name:
#* Created: 
#* Author: 
#*=============================================================================
#* Purpose: Place a log file on the active users desktop listing all the background services on the Mac
#*=============================================================================
 
#*=============================================================================
#* REVISION HISTORY
#*=============================================================================
#* Date: 
#* Author: 
#* Issue: 
#* Solution: 
#*=============================================================================
#* Date: 
#* Author: 
#* Issue: 
#* Solution: 
#*=============================================================================
 
#*=============================================================================
#* GLOBAL VARIABLES
#*=============================================================================
 
#JAMF Helper - 
#JAMF Helper function can be removed if not needed. Lines 30-53
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
windowType="hud"
description="Identifying apps using background task management.
 
sfltool.log has been exported to your desktop.
 
Click open to open the log file in console.
Click cancel to open the log file manually.
 
***This Window will Not dismiss automatically***
 
 
If you require assistance, please email."
heading="Background Service Task Management"
button1="Open"
button2="Cancel"
icon="/Library/Desktop Pictures/DesktopBG_8x5_v4_1703.jpg"
title="Background Service Task Management" 
defaultButton="1"
cancelButton="2"
iconSize="240"
#End JAMF Helper
 
#Active User
#Defining Active user to place log file on their desktop. Required to generate log file.
DIV1='echo ####################################################################'
DIV2='echo --------------------------------------------------------------------'
DIV3='echo ....................................................................'
ActiveUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }' | tr "[a-z]" "[A-Z]"`
#End #Active User
 
 
 
#*=============================================================================
#* Script Function
#*=============================================================================
 
#Generate the log file and place on the users desktop.
sudo sfltool dumpbtm > /users/$ActiveUser/desktop/sfltool.log
 
#Echoing log path for reporting.
echo "sfltool dumpbtm has been exported to /users/$ActiveUser/desktop/sfltool.log"
 
#Running JAMF Helper
#May be removed if JAMF Helper is not being used. Lines 75-77.
userChoice=$("$jamfHelper" -windowType "$windowType" -title "$title" -heading "$heading" -description "$description" -defaultButton "$defaultButton" -cancelButton "$cancelButton" -icon "$icon" -iconSize "$iconSize" -alignHeading "$alignHeading" -button1 "$button1" -button2 "$button2")
 
#*=============================================================================
#* End Script Function
#*=============================================================================
 
#Rebooting device or canceling based on user choice
#Remove if JAMF Helper is not needed. Lines 83-92. Uncomment Line 95.
if [ "$userChoice" == "0" ]; then
                echo "User Selected Open, /users/$ActiveUser/desktop/sfltool.log will open in console."
                open /users/$ActiveUser/desktop/sfltool.log
                exit 0 
elif [ "$userChoice" == "2" ]; then
                echo "User clicked Cancel; now exiting."
                exit 1 
fi

#Opens the log file if JAMF Helper is not being used.
#open /users/$ActiveUser/desktop/sfltool.log
