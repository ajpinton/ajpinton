#############################################
# Script Name: .ps1
# Author: Anthony Pinto
# Purpose: 
# Date: 9.10.23
#############################################

# Define the list of computer names
$computerList = @("Computer1", "Computer2", "Computer3")

# Function to uninstall Google Chrome
function Uninstall-Chrome {
    param (
        [string]$computerName
    )
    
    try {
        Write-Host "[$computerName] Checking for Google Chrome..."
        
        # Check if Google Chrome is installed
        $chromeInstalled = Get-WmiObject -Class Win32_Product -ComputerName $computerName | Where-Object { $_.Name -like "*Google Chrome*" }

        if ($chromeInstalled) {
            Write-Host "[$computerName] Google Chrome found. Uninstalling..."
            
            # Uninstall Google Chrome
            $uninstallResult = Invoke-Command -ComputerName $computerName -ScriptBlock {
                Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList "--uninstall --system-level" -Wait
            }
            
            if ($uninstallResult.ExitCode -eq 0) {
                Write-Host "[$computerName] Google Chrome successfully uninstalled."
                return 0
            } else {
                Write-Host "[$computerName] Failed to uninstall Google Chrome. Exit code: $($uninstallResult.ExitCode)"
                return 1
            }
        } else {
            Write-Host "[$computerName] Google Chrome is not installed."
            return 0
        }
    } catch {
        Write-Host "[$computerName] Error: $_"
        return 1
    }
}

# Loop through the list of computers and uninstall Google Chrome
foreach ($computer in $computerList) {
    $result = Uninstall-Chrome -computerName $computer
    if ($result -eq 0) {
        Write-Host "[$computer] Uninstallation completed successfully."
    } else {
        Write-Host "[$computer] Uninstallation failed."
    }
}

# Exit code: 0 if all uninstallations were successful, 1 if any uninstallation failed
if ($computerList | ForEach-Object { Uninstall-Chrome -computerName $_ }) {
    exit 0
} else {
    exit 1
}
