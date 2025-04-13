#!/bin/bash

#*=============================================================================
#* Script Name: Configure_Install.log_Retention_to_365 (CIS 7.9).sh
#* Created: [04/03/25]
#* Author: You, fixing other people's mistakes
#*=============================================================================
#* Purpose: Checks the Install Log retention to ensure TTL is set to 365 days.
#* Purpose: If Install log is not 365 days, the script will set it to 365 days.
#* Purpose: If Install Log is set to 365 days, the script will exit.
#*=============================================================================

#*=============================================================================
#* Exit Codes
#*=============================================================================
#* 0 = Successful
#* 1 = Failed and TTL is not set to 365
#*=============================================================================

# File to check and modify
config_file="/etc/asl/com.apple.install"

# Check if ttl=365 is already set in the configuration file
ttl_value=$(grep "ttl=" "$config_file")

if [ -z "$ttl_value" ] || [ "$ttl_value" != "ttl=365" ]; then
    # ttl is either not set or not set to 365, update the configuration
    sudo /usr/bin/sed -i '' "s/\* file \/var\/log\/install.log.*/\* file \/var\/log\/install.log format='\$\(\(Time\)\(JZ\)\) \$Host \$\(Sender\)\[\$\(PID\\)\]: \$Message' rotate=utc compress file_max=50M size_only ttl=365/g" "$config_file"
fi

# Verify if the ttl is set to 365
ttl_value=$(grep "ttl=365" "$config_file")

if [ -n "$ttl_value" ]; then
    echo "TTL is set to 365."
    exit 0
else
    echo "TTL is not set to 365."
    exit 1
fi
