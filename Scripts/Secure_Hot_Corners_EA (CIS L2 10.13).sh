#!/bin/bash

#*=============================================================================
#* Script Name: Secure_Hot_Corners_EA (CIS L2 10.13)
#* Created: [04/03/25]
#* Author: You, fixing other people's mistakes
#*=============================================================================
#* Purpose: Checks to see if the Active User has insecure Hot Corners Enabled (ie supressing sleep) and report status
#*=============================================================================

user=$(stat -f "%Su" /dev/console)
plist="/Users/$user/Library/Preferences/com.apple.dock.plist"

# Check each corner for value 6 (prevent sleep)
bl=$(sudo -u "$user" defaults read "$plist" wvous-bl-corner 2>/dev/null)
br=$(sudo -u "$user" defaults read "$plist" wvous-br-corner 2>/dev/null)
tl=$(sudo -u "$user" defaults read "$plist" wvous-tl-corner 2>/dev/null)
tr=$(sudo -u "$user" defaults read "$plist" wvous-tr-corner 2>/dev/null)

if [[ "$bl" == "6" || "$br" == "6" || "$tl" == "6" || "$tr" == "6" ]]; then
    echo "<result>Not Compliant</result>"
else
    echo "<result>Compliant</result>"
fi