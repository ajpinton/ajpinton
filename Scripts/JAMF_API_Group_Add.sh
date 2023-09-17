#!/bin/zsh

#############################################
# Script Name: JAMF_API_Group_Add.zsh
# Author: 
# Purpose: Reads a list of devices from a spreadsheet and adds those devices to a static group
# Date: 
#############################################

# Set your JAMF Pro URL and credentials
JAMF_URL="https://your-jamf-url.com"
API_USERNAME="your-api-username"
API_PASSWORD="your-api-password"

# Set the ID of the static group you want to add devices to
STATIC_GROUP_ID="123"

# Specify the path to the text file containing serial numbers
SERIAL_NUMBERS_FILE="serial_numbers.txt"

# Loop through each serial number in the file
while IFS= read -r SERIAL_NUMBER
do
  # Make an API request to add the device to the static group
  curl -X PUT -u "$API_USERNAME:$API_PASSWORD" \
    "$JAMF_URL/JSSResource/computergroups/id/$STATIC_GROUP_ID" \
    -H "Content-Type: application/xml" \
    -d "<computer_group><computer_additions><computer><serial_number>$SERIAL_NUMBER</serial_number></computer></computer_additions></computer_group>"
    
  # Check if the API request was successful (you may need to modify this based on JAMF's API response)
  if [ $? -eq 0 ]; then
    echo "Added device with serial number $SERIAL_NUMBER to static group $STATIC_GROUP_ID"
  else
    echo "Failed to add device with serial number $SERIAL_NUMBER to static group $STATIC_GROUP_ID"
  fi
done < "$SERIAL_NUMBERS_FILE"
