#!bin/bash
#*=============================================================================
#* Script Name: 
#* Created: 
#* Author: 
#*=============================================================================
#* Purpose: Decrpyt string, mainly for the purpose of securely passing password
#* through JAMF.
### Useage guide ###
#* Add this script to the JAMF script that is needing to use an encryped password
#* $Salt should come from the password_encrypt script and manually entered in this script
#* $Pass should come from the password_encrypt script and manually entered in this script
#* $EncrypedString should come from the JAMF policy and not be placed in this string
#* $DecrypedString should be used in place of the password in the script
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


#*------------------------ STRING DECRYPTION ------------------------*#
Salt="" #Add salt withing quotes
Pass="" #Add passphrase withing quotes
function DecryptString() {
echo "${1}" | /usr/bin/openssl enc -aes256 -d -a -A -S "${2}" -k "${3}"
}

#* Usage: ~$ DecryptString "Encrypted String" "Salt" "Passphrase"
#* Point $password to the external source (script parameter) containing the encrypted string.
DecryptedString=$(DecryptString "$ENCRYPTEDSTRING" "$Salt" "$Pass")
#*------------------------ STRING DECRYPTION ------------------------*#