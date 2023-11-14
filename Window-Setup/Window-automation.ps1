<#
Script Name: Window Automation 
Author: Jason Dallas
Date of latest revision: 11/13/2023
Purpose: Perform basic tasks
#>

# User Generates User Account
# Define the username and password for the new user
$username = "User"
$password = ConvertTo-SecureString "Password" -AsPlainText -Force

# Create a new local user without admin privileges
New-LocalUser -Name $username -Password $password -UserMayNotChangePassword -PasswordNeverExpires

# Set the PasswordExpired attribute to enforce password change after login
net user $username /logonpasswordchg:yes

# Optional: Add the user to the Users group
Add-LocalGroupMember -Group "Users" -Member $username

Write-Host "User $username created successfully. Password change is required at the next login."


# Adds App Shortcuts
$apps = @{
    'Slack'        = 'https://downloads.slack-edge.com/releases/win64/4.25.0/Slack-Setup.exe'
    'Google Chrome' = 'https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi'
    'Zoom'         = 'https://zoom.us/client/latest/ZoomInstallerFull.msi'
    'LibreOffice'  = 'https://download.documentfoundation.org/libreoffice/stable/7.2.2/win/x86_64/LibreOffice_7.2.2_Win_x64.msi'
    'Thunderbird'  = 'https://download-installer.cdn.mozilla.net/pub/thunderbird/releases/91.4.0/win64/en-US/Thunderbird%20Setup%2091.4.0.exe'
}

$downloadPath = "$env:TEMP\Downloads"
$desktopPath = [System.Environment]::GetFolderPath('Desktop')

# Create the Downloads directory if it doesn't exist
if (-not (Test-Path -Path $downloadPath -PathType Container)) {
    New-Item -Path $downloadPath -ItemType Directory
}

foreach ($app in $apps.GetEnumerator()) {
    $appName = $app.Key
    $appUrl = $app.Value
    $appInstaller = Join-Path $downloadPath "$appName.Installer"

    Invoke-WebRequest -Uri $appUrl -OutFile $appInstaller
    Start-Process -FilePath $appInstaller -Wait -Force

    (New-Object -ComObject WScript.Shell).CreateShortcut("$desktopPath\$appName.lnk").TargetPath = $appInstaller
    Remove-Item -Path $appInstaller -Force
}

Write-Host "Installation and shortcut creation completed."

# Changes background to Company Logo
# URL of the image
$imageUrl = "https://raw.githubusercontent.com/avalon-lake-tech/mrbeast-scripts/main/avalonlake-desktop.png"

# Path to save the image
$imagePath = "$env:TEMP\avalonlake-desktop.png"

# Download the image
Invoke-WebRequest -Uri $imageUrl -OutFile $imagePath

# Set the image as the desktop background
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@

[Wallpaper]::SystemParametersInfo(20, 0, $imagePath, 3)

# Clean up: Remove the downloaded image
Remove-Item $imagePath
