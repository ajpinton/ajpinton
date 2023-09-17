#############################################
# Script Name: File_Search.ps1
# Author: 
# Purpose: Establish PowerShell Remote session, and search c:\ccmcache for $fileToFind on remote device.
# Date: 
#############################################

fileToFind = Aternity

# Check if the WinRM service is running, and if not, start it
$winrmService = Get-Service -Name "winrm"
if ($winrmService.Status -ne "Running") {
    Start-Service -Name "winrm"
}

# Input machine name
$machineName = Read-Host "Enter the machine name"

# Try to establish a Remote PowerShell session
try {
    $session = New-PSSession -ComputerName $machineName -Credential (Get-Credential)
    Write-Host "Remote PowerShell session established successfully."

    # Search for the '$fileToFind' file in the C:\Windows\ccmcache directory recursively
    $searchPath = "\\$machineName\C$\Windows\ccmcache"
    $files = Get-ChildItem -Path $searchPath -Recurse -Filter "$fileToFind" -File

    if ($files.Count -gt 0) {
        Write-Host "Found the following '$fileToFind' files:"
        foreach ($file in $files) {
            Write-Host $file.FullName
        }
    } else {
        Write-Host "No '$fileToFind' files found in $searchPath."
    }
} catch {
    Write-Host "Failed to establish a Remote PowerShell session to $machineName. Error: $_"
}

# Close the session
if ($session) {
    Remove-PSSession $session
}
