#!/bin/bash

#*=============================================================================
#* Script Name: Set_Audit_Retention_(CIS 6.14)_EA
#* Created: [04/10/25]
#* Author: You, fixing other people's mistakes
#*=============================================================================
#* Purpose: Checks and reports `expire-after` in /etc/security/audit_control for "60d OR 1G"
#*=============================================================================

#!/bin/bash

# Extension Attribute: Audit Retention Compliance
# Checks if `expire-after` is set to "60d OR 1G"

EXPECTED="60d OR 1G"
CURRENT=$(awk -F: '/^expire-after/ {print $2}' /etc/security/audit_control | xargs)

if [[ "$CURRENT" == "$EXPECTED" ]]; then
    RESULT="Compliant"
else
    RESULT="Not Compliant"
fi

echo "<result>$RESULT</result>"
