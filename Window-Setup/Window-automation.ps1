<#
Script Name: Window Automation 
Author: Jason Dallas
Date of latest revision: 11/13/2023
Purpose: Perform basic tasks
#>

 # Define the username and password
$username = "User"
$password = "YourNewPassword"

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force

# Create the new local user account
New-LocalUser -Name $username -Password $securePassword -PasswordNeverExpires:$true -UserMayNotChangePassword:$false

# Force password change on next login
Set-LocalUser -Name $username -PasswordExpired

Write-Host "User account '$username' created with password change on next login."


# Adds App Shortcuts
# Define download URLs for the applications
$chromeUrl = "https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi"
$zoomUrl = "https://zoom.us/client/latest/ZoomInstallerFull.msi"
$thunderbirdUrl = "https://download-installer.cdn.mozilla.net/pub/thunderbird/releases/91.7.0/win64/en-US/Thunderbird%20Setup%2091.7.0.exe"

# Define installation paths
$installPath = "$env:ProgramFiles\"

# Define desktop shortcut paths
$desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'))

# Function to install application
function Install-Application {
    param(
        [string]$url,
        [string]$installPath
    )

    # Download the installer
    $installerPath = Join-Path $installPath (Split-Path $url -Leaf)
    Invoke-WebRequest -Uri $url -OutFile $installerPath

    # Install the application
    Start-Process -FilePath $installerPath -Wait

    # Remove the installer (optional)
    Remove-Item -Path $installerPath -Force
}

# Function to remove application
function Remove-Application {
    param(
        [string]$appName
    )

    # Remove the application if it exists
    $appPath = Join-Path $installPath $appName
    if (Test-Path $appPath) {
        Remove-Item -Path $appPath -Recurse -Force
    }
}

# Install Google Chrome
Install-Application -url $chromeUrl -installPath $installPath

# Install Zoom
Install-Application -url $zoomUrl -installPath $installPath

# Install Thunderbird
Install-Application -url $thunderbirdUrl -installPath $installPath

# Remove Slack
Remove-Application -appName "Slack"

# Create desktop shortcuts
$WshShell = New-Object -ComObject WScript.Shell

$WshShell.CreateShortcut("$desktopPath\Google Chrome.lnk").TargetPath = "$installPath\Google\Chrome\Application\chrome.exe"
$WshShell.CreateShortcut("$desktopPath\Zoom.lnk").TargetPath = "$installPath\Zoom\Zoom.exe"
$WshShell.CreateShortcut("$desktopPath\Thunderbird.lnk").TargetPath = "$installPath\Mozilla Thunderbird\thunderbird.exe"

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
