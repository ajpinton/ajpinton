#!/bin/bash

#=============================================================================
# Script Name: Remove_TTL_from_Install_Log (Undo CIS 7.9)
# Created: [04/11/25]
# Author: You, still fixing things
#=============================================================================
# Purpose: Removes `ttl=365` from the install log configuration without touching other settings
#=============================================================================

config_file="/etc/asl/com.apple.install"

# Check if the file exists
if [ ! -f "$config_file" ]; then
    echo "Install log config file not found."
    exit 1
fi

# Remove only the ttl=365 portion, preserve other config flags
/usr/bin/sed -i '' 's/ ttl=365//g' "$config_file"

# Validate removal
if grep -q "ttl=365" "$config_file"; then
    echo "Failed to remove ttl=365."
    exit 1
else
    echo "Successfully removed ttl=365 from config."
    exit 0
fi
