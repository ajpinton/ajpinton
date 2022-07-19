#!/bin/bash
user501=$(dscl . search  /Users UniqueID 501 | cut -sf1)
echo "<result>$UID</result>"