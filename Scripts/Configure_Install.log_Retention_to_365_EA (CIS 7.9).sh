#!/bin/bash

#*=============================================================================
#* Script Name: Install.log Retention TTL 365 Days.sh
#* Created: [04/03/25]
#* Author: You, fixing other people's mistakes
#*=============================================================================
#* Purpose: Checks the TTL status of install.log
#*=============================================================================

# Check if ttl is set to 365 in the ASL config for install.log
ttl_value=$(grep "ttl=365" /etc/asl/com.apple.install)

# Output result based on the presence of ttl=365
if [ -z "$ttl_value" ]; then
    echo "<result>No Compliant</result>"
else
    echo "<result>Compliant</result>"
fi