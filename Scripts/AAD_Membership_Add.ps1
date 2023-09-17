#############################################
# Script Name: AAD_Membership_Add.ps1
# Author: 
# Purpose: Script to manage membership in an Azure AD group based on the list of machine names provided in the selected text file. 
# Date: 
#############################################

$azgroup = "Some Group Name Here"

#Checks if 'Azuread' module is available. 
#If available, import the module.
if (Get-Module -ListAvailable -Name Azuread)
{
Import-Module Azuread
}

#If not available, check to see if current user has admin privliges. If the user is not an admin, return 0. If the user is an admin, attempt to install the module with the force switch.
else {
        if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent ()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole] "Administrator")) {
        return (0)
            }
    else {
            Install-Module AzureAD -Confirm:$False -Force
        }
}

#Create dialog box to prompt the user to select a .txt file.
$FileBrowser = New-Object System.Windows.Forms. OpenFileDialog -Property @{
    InitialDirectory = [Environment]:: GetFolderPath ('Desktop')
    Filter = 'Documents (*.txt) *.txt Textile (*.txt) *.txt'
}

#Show the selected files and set the output to the $machines variable
$null = $FileBrowser.ShowDialog ()
$machines = get-content $FileBrowser. FileName

#Connect to AAD
Connect-AzureAD
$objid = (get-azureadgroup -Filter "DisplayName eq '$azgroup'" ).objectid
$members = Get-AzureADGroupMember -ObjectId $objid -all $true | select displayname

#Loop for each device in $machines, attempt to find AAD devices that match machine name. 
foreach ($  in $machines) {

    $refid = Get-AzureADDevice - Filter "DisplayName eq '$machine*" | Where-Object {S_.IsCompliant -eq STrue}

    #For each check to see if the device is already a member of the AD Group.
    foreach($ref in $refid){
    $result = $null
    $result = ($members -match $machine)
    if(!$result){
        #If the device is not a member of the group, attempt to add the device.
        try{
            Add-AzureADGroupMember -ObjectId $objid -RefObjectId $ref.objectid
            }
        #If there is an error, catches the displayed error message.
        catch{
            write-host "An error occured for " $ref. displayname -ForegroundColor Red
            }
        else
        #If the device is already a member, display message staying "is already a member"
        {
            write-host $machine " is already a member" -ForegroundColor Green
        }   
        }
    }
}
