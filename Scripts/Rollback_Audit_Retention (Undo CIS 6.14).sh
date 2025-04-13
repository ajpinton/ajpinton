#!/bin/bash

#=============================================================================
# Script Name: Rollback_Audit_Retention (Undo CIS 6.14)
# Created: [04/11/25]
# Author: You, still fixing other people's mistakes
#=============================================================================
# Purpose: Reverts /etc/security/audit_control to its backed-up version
#=============================================================================
# Exit Codes:
# 0 = Success
# 1 = No backup found or rollback failed
#=============================================================================

AUDIT_CONTROL="/etc/security/audit_control"
BACKUP_FILE="/etc/security/audit_control.bak"

echo "Starting rollback of audit retention configuration..."

# Check for backup
if [[ ! -f "$BACKUP_FILE" ]]; then
    echo "No backup file found. Cannot perform rollback."
    exit 1
fi

# Remove immutable flag if set
if ls -lO "$AUDIT_CONTROL" | grep -q uchg; then
    echo "Audit control file is immutable. Removing immutable flag..."
    chflags nouchg "$AUDIT_CONTROL"
    sleep 1
fi

# Restore backup
cp "$BACKUP_FILE" "$AUDIT_CONTROL"
if [[ $? -ne 0 ]]; then
    echo "Failed to restore backup."
    exit 1
fi

# Reapply settings
/usr/sbin/audit -s
sleep 1

echo "Rollback complete. Audit retention configuration has been restored."
exit 0