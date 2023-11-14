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
# Define the list of applications and their download links
$apps = @{
    'Slack'        = 'https://downloads.slack-edge.com/releases/win64/4.25.0/Slack-Setup.exe'
    'Google Chrome' = 'https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi'
    'Zoom'         = 'https://zoom.us/client/latest/ZoomInstallerFull.msi'
    'LibreOffice'  = 'https://download.documentfoundation.org/libreoffice/stable/7.2.2/win/x86_64/LibreOffice_7.2.2_Win_x64.msi'
    'Thunderbird'  = 'https://download-installer.cdn.mozilla.net/pub/thunderbird/releases/91.4.0/win64/en-US/Thunderbird%20Setup%2091.4.0.exe'
}

# Set the path to the desktop
$desktopPath = [System.Environment]::GetFolderPath('Desktop')

# Create a folder for the downloads on the desktop
$downloadFolderPath = Join-Path -Path $desktopPath -ChildPath 'AppDownloads'
New-Item -ItemType Directory -Force -Path $downloadFolderPath

# Download and install each application
foreach ($appName in $apps.Keys) {
    $appDownloadLink = $apps[$appName]
    $appInstallerPath = Join-Path -Path $downloadFolderPath -ChildPath "$appName Installer"

    # Download the application installer
    Invoke-WebRequest -Uri $appDownloadLink -OutFile $appInstallerPath

    # Install the application silently (assuming they support silent installation)
    Start-Process -FilePath $appInstallerPath -ArgumentList '/quiet', '/norestart' -Wait

    # Create a shortcut on the desktop
    $shortcutPath = Join-Path -Path $desktopPath -ChildPath "$appName.lnk"
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $appInstallerPath
    $Shortcut.Save()
}

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
