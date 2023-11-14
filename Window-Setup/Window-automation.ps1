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
# Define download URLs for the applications
$chromeUrl = "https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi"
$zoomUrl = "https://zoom.us/client/latest/ZoomInstallerFull.msi"
$slackUrl = "https://slack.com/downloads/instructions/windows"
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

# Install Google Chrome
Install-Application -url $chromeUrl -installPath $installPath

# Install Zoom
Install-Application -url $zoomUrl -installPath $installPath

# Install Slack
Install-Application -url $slackUrl -installPath $installPath

# Install Thunderbird
Install-Application -url $thunderbirdUrl -installPath $installPath

# Create desktop shortcuts
$WshShell = New-Object -ComObject WScript.Shell

$WshShell.CreateShortcut("$desktopPath\Google Chrome.lnk").TargetPath = "$installPath\Google\Chrome\Application\chrome.exe"
$WshShell.CreateShortcut("$desktopPath\Zoom.lnk").TargetPath = "$installPath\Zoom\Zoom.exe"
$WshShell.CreateShortcut("$desktopPath\Slack.lnk").TargetPath = "$installPath\Slack\slack.exe"
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
