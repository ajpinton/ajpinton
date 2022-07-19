#!/bin/bash

######################
# Script Name: 
# Author: 
# Date: 05.20.21
# Enhancements
# Update to the previous script to move to using sysadminctl rather than fdesetup to provision user access
# fdesetup to provision user access has been deprecated 
# Comments:
# Commented out 127-140 which verify if the account is on the domain controler, there appears to be some issues with this function
# Will need to update 147 with the new sysadminctl work flow
######################

######################
# Exit Codes
# 0 - Sucess: General Sucess
# 1 - Failed: Admin account credentials are not correct
# 2 - Failed: Mac not domain bound, or otherwise cannot talk to the domain controller
# 3 - Failed: User account to be cached not found in Active Directory
# 4 - Sucess: FileVault Not enabled
###################### 

echo "Begin script"

######################
# Gather and verify admin account
# Uses JAMF parameter 4 and 5 for the account with a FileVault token to pass so the username and password do not need to be in the script
# The admin password may be salted instead of using $5 for the password, it can be used for the decrypt string to encrypt the local admin password
######################

#*------------------------ STRING DECRYPTION ------------------------*#

#function DecryptString() {
#    echo "${1}" | /usr/bin/openssl enc -aes256 -d -a -A -S "${2}" -k "${3}"
#}

#Pass=""
#Salt=""
#DecryptString=$(DecryptString "$5" "$Salt" "$Pass") 
        

adminUser="$4"
#adminPass="$DecryptString" #not needed unless you salt the password. If this is used comment out line 45.
adminPass="$5"

#Checks OS version
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
#Checks for active directory binding
check4AD=`/usr/bin/dscl localhost -list . | grep "Active Directory"`

## verify that adminuser and pass variables are both passed to the user
if [[ -z "$adminUser" ]] || [[ -z "$adminPass" ]] ; then
    dialog="either Admin User or Password is missing"
    echo "$dialog"
    cmd="Tell app \"System Events\" to display dialog \"$dialog\""
    /usr/bin/osascript -e "$cmd"
    exit 1
fi

## check the admin password
adminCheck=$(/usr/bin/dscl /Local/Default -authonly "$adminUser" "$adminPass")
if [[ -z "$adminCheck" ]] ; then
    echo "Admin password is verified"
else
    echo "Admin Password not working"
    exit 1
fi


######################
# Check for domain bind, fails out of not bound
######################

echo "Checking for Domain Bind"


if [ "${check4AD}" != "Active Directory" ]; then
    dialog="This machine is not bound to Active Directory, Please bind to AD first. "
    echo "$dialog"
    cmd="Tell app \"System Events\" to display dialog \"$dialog\""
    /usr/bin/osascript -e "$cmd"
    exit 2
fi

######################
# Popups asking for user to ender userID and Password
######################

echo "Prompting for userToAdd credentials."

## Prompt for Username
userToAdd=$(/usr/bin/osascript<<END
tell application "System Events"
activate
set the answer to text returned of (display dialog "Enter your userID:" default answer "" buttons {"Continue"} default button 1)
end tell
END
)

## Prompt for Password
userPass=$(/usr/bin/osascript<<END
tell application "System Events"
activate
set the answer to text returned of (display dialog "Enter your Password:" default answer "" with hidden answer buttons {"Continue"} default button 1)
end tell
END
)

loopCount=0
while [ "$loopCount" -lt 3 ]; do
    # Refresh Directory Services
    if [[ ${osvers} -ge 7 ]]; then
        /usr/bin/killall opendirectoryd
    else
        /usr/bin/killall DirectoryService
    fi
    sleep 15

    ## try to auth the user in advance. this seems to increase the success of the ID command.
    /usr/bin/dscl /Search -authonly "$userToAdd" "$userPass"

    adCheck=`id $userToAdd`
    echo "AD Check is: $adCheck"
    if [[ -z "$adCheck" ]] ; then
        ((loopCount++))
    else
        echo "AD Check successful"
        break
    fi
done 

######################
# Fails script if user account is not found on domain controller
######################

if [[ -z "$adCheck" ]] ; then
    dialog="AD User Not found. Please contact (Some contact information here)"
    echo "$dialog"
    cmd="Tell app \"System Events\" to display dialog \"$dialog\""
    /usr/bin/osascript -e "$cmd"
    exit 3
fi

sleep 2

######################
# Remove FV Access if existing
###################### 

#Some times there will be an existing FV record for the user that needs to be removed.
sleep 2
sudo fdesetup remove -user $userToAdd

######################
# Provision Admin Access
###################### 

dscl . -append /groups/admin GroupMembership $userToAdd
echo "Provisioning admin access for $userToAdd."

######################
# Provision FileVault Access
###################### 

# Section may be uncommented if FileVault may not be encryped when the script is used.

## Check to see if the encryption process is complete
#encryptCheck=fdesetup status\
#statusCheck=$(echo "${encryptCheck}" | grep "FileVault is On.")
#expectedStatus="FileVault is On."
#    if [ "${statusCheck}" != "${expectedStatus}" ]; then 
#        echo "The encryption process has not completed, unable to add user at this time." echo "${encryptCheck}" exit 4
#    else
#        echo "Adding $userToAdd to FileVault 2 list."
#    fi
#
#sleep 5

## Get the user to be added to FV
userName=$userToAdd

## This "expect" block will populate answers for the sysadminctl variables.

sysadminctl -adminUser "$adminUser" -adminPassword "$adminPass" -secureTokenOn "$userName" -password "$userPass"

echo "${userName} has been added to the FileVault 2 list."


######################
# Runs JAMF Recon to assign Mac to $userToAdd
###################### 

jamf recon -endUsername $userToAdd

######################
# Clean up
###################### 

echo "Script completed"


exit 0