#############################################
# Script Name: Chrome_Uninstall_String.ps1
# Author: 
# Purpose: Checks the intall status of Chrome, and prints version and uninstall string
# Date: 
#############################################

# Define the registry path for Google Chrome installation information
$chromeRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"

# Check if Google Chrome is installed by searching for its registry key
$chromeKey = Get-ItemProperty -Path $chromeRegistryPath | Where-Object { $_.DisplayName -like "Google Chrome" }

if ($chromeKey) {
    # Google Chrome is installed, retrieve and display the information
    $appName = $chromeKey.DisplayName
    $appVersion = $chromeKey.DisplayVersion
    $uninstallString = $chromeKey.UninstallString

    Write-Host "Application Name: $appName"
    Write-Host "Version: $appVersion"
    Write-Host "Uninstall String: $uninstallString"
} else {
    # Google Chrome is not installed
    Write-Host "Google Chrome is not installed on this machine."
}
