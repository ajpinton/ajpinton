#!/bin/bash

#=============================================================================
# Script Name: Configure_Audit_Retention_to_60d_OR_5G (CIS 6.14).sh
# Created: [04/10/25]
# Author: You, fixing other people's mistakes
#=============================================================================
# Purpose: Checks and sets `expire-after` in /etc/security/audit_control to "60d OR 1G"
#=============================================================================
# Exit Codes:
# 0 = Successful
# 1 = Failed to remove insecure hot corners
# 2 = No user logged in
#=============================================================================

AUDIT_CONTROL="/etc/security/audit_control"
EXPECTED_SETTING="60d OR 1G"

# Function to get current expire-after value
get_current_setting() {
    awk -F: '/^expire-after/ {print $2}' "$AUDIT_CONTROL" | xargs
}

echo "Starting Audit Retention Configuration Script..."

# Check if the file is immutable
if ls -lO "$AUDIT_CONTROL" | grep -q uchg; then
    echo "Audit control file is immutable. Removing immutable flag..."
    chflags nouchg "$AUDIT_CONTROL"
    sleep 1
else
    echo "Audit control file is not immutable. Proceeding..."
fi

CURRENT_SETTING=$(get_current_setting)
echo "Current expire-after setting: $CURRENT_SETTING"

# Set new value only if different
if [[ "$CURRENT_SETTING" != "$EXPECTED_SETTING" ]]; then
    echo "Updating expire-after setting to: $EXPECTED_SETTING"
    sed -i.bak "s/^expire-after.*/expire-after:$EXPECTED_SETTING/" "$AUDIT_CONTROL"
    /usr/sbin/audit -s
    sleep 1
else
    echo "expire-after is already set correctly. No change needed."
fi

NEW_SETTING=$(get_current_setting)
echo "New expire-after setting: $NEW_SETTING"

# Exit with proper code
if [[ "$NEW_SETTING" == "$EXPECTED_SETTING" ]]; then
    echo "Audit retention successfully set to: $NEW_SETTING"
    exit 0
else
    echo "Failed to update audit retention setting. Still set to: $NEW_SETTING"
    exit 1
fi
