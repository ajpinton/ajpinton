#!/bin/bash
#*=============================================================================
#* Script Name: 
#* Created: 
#* Author: 
#*=============================================================================
#* Purpose: Encrypt string, mainly for the purpose of securely passing password
#* through JAMF.
#### Useage Guide
#* Run this script locally - DO NOT include in the final JAMF policy####
#* Place password decrypt script script with appropreate information in the JAMF Policy and JAMF Script
#* $Salt should be placed in the password decryption section of the script that needs the encryped password
#* $Pass should be placed in the password decryption section of the script that needs the encryped password
#* $EncrypedString be placed in the JAMF policy as a parameter
#*=============================================================================



#*=============================================================================
#* REVISION HISTORY
#*=============================================================================
#* Date: 
#* Author: 
#* Issue:
#* Solution:
#*=============================================================================

#*=============================================================================
#* FUNCTION LISTINGS
#*=============================================================================

function GenerateEncryptedString() {
echo "Enter string you would like to encrypt:"
read STRING
local SALT=$(openssl rand -hex 8)
local K=$(openssl rand -hex 12)
local ENCRYPTED=$(echo "${STRING}" | openssl enc -aes256 -a -A -S "${SALT}" -k "${K}")
clear
echo ""
echo ""
echo "============================================================================="
echo "============================================================================="
echo "Salt: ${SALT}"
echo "Passphrase: ${K}"
echo "Encrypted String: ${ENCRYPTED}"
echo ""
echo "Usage Notes: Include the Salt and Passphrase in your final JAMF script."
echo " The Encrypted String should ONLY be passed through a script"
echo " parameter inside the policy."
echo "============================================================================="
echo "============================================================================="
echo ""
echo ""
}
#*=============================================================================
#* SCRIPT BODY
#*=============================================================================
echo ""
echo "============================================================================="
echo "Regions BASH String Encription Program"
echo "============================================================================="
echo "This program ecrypts strings to AES256 standards"
GenerateEncryptedString
#*=============================================================================
#* END OF SCRIPT
#*=============================================================================