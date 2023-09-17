#!/bin/zsh

#############################################
# Script Name: JAMF_API_EraseDevice.sh
# Author: 
# Purpose: Issue API to issue MDM Command from JAMF to eraseDevice on the provded list of devices.
# Date: 
# Comment: Script is still in development
#############################################

# JAMF Pro API URL
JAMF_API_URL="https://your-jamf-server-url/JSSResource"

# Bearer token for API authentication
BEARER_TOKEN="your-bearer-token"

# Path to the text document containing serial numbers (one per line)
SERIAL_NUMBERS_FILE="serial_numbers.txt"

# Passcode for the "EraseDevice" command
PASSCODE="123456"

# Function to look up the computer ID by serial number using the API
get_computer_id_by_serial() {
  local api_url="$1"
  local bearer_token="$2"
  local serial_number="$3"

  # Send a GET request to retrieve the computer ID by serial number
  local computer_id=$(curl -s -H "Authorization: Bearer ${bearer_token}" -H "Accept: application/xml" "${api_url}/computers/serialnumber/${serial_number}" | xmllint --xpath "//computer/id/text()" -)

  echo "${computer_id}"
}

# Function to initiate the "EraseDevice" command for a specific computer by ID
erase_device_command() {
  local api_url="$1"
  local bearer_token="$2"
  local computer_id="$3"
  local passcode="$4"

  # Send a POST request to initiate the "EraseDevice" command
  local response_code=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer ${bearer_token}" -H "Content-Type: application/xml" -X POST "${api_url}/computers/id/${computer_id}/commands/EraseDevice/passcode/${passcode}")

  if [[ ${response_code} -eq 201 ]]; then
    echo "EraseDevice command initiated successfully for Computer ID: ${computer_id}"
  else
    echo "Failed to initiate EraseDevice command for Computer ID: ${computer_id} (HTTP Status Code: ${response_code})."
  fi
}

# Read serial numbers from the text document and initiate EraseDevice for each
while read -r serial; do
  computer_id=$(get_computer_id_by_serial "${JAMF_API_URL}" "${BEARER_TOKEN}" "${serial}")
  if [[ -n "${computer_id}" ]]; then
    erase_device_command "${JAMF_API_URL}" "${BEARER_TOKEN}" "${computer_id}" "${PASSCODE}"
  else
    echo "Computer with Serial: ${serial} not found in JAMF Pro."
  fi
done < "${SERIAL_NUMBERS_FILE}"
