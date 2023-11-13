<#
Script Name: Window Automation 
Author: Jason Dallas
Date of latest revision: 11/13/2023
Purpose: Perform basic tasks
#>

# User Generates User Account
$username = "User"
$password = "YourStrongPassword"
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
New-LocalUser -Name $username -Password $securePassword -PasswordNeverExpires $false -UserMayNotChangePassword $false -AccountNeverExpires $false
Set-LocalUser -Name $username -PasswordChangeableDate (Get-Date).AddMinutes(-5)

# Adds App Shortcuts
$apps = @{
    'Slack'        = 'C:\Users\YourUsername\AppData\Local\slack\slack.exe'
    'Google Chrome' = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
    'Zoom'         = 'C:\Users\YourUsername\AppData\Roaming\Zoom\bin\Zoom.exe'
    'LibreOffice'  = 'C:\Program Files\LibreOffice\program\soffice.exe'
    'Thunderbird'  = 'C:\Program Files\Mozilla Thunderbird\thunderbird.exe'
}
$desktopPath = [System.Environment]::GetFolderPath('Desktop')
$apps.GetEnumerator() | ForEach-Object {
    $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut("$desktopPath\$($_.Key).lnk")
    $shortcut.TargetPath = $_.Value
    $shortcut.Save()
}

# Changes background to Company Logo
$ImageUrl = "https://github.com/avalon-lake-tech/mrbeast-scripts/raw/main/avalonlake-desktop.png"
$ImagePath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "avalonlake-desktop.png")
Invoke-WebRequest -Uri $ImageUrl -OutFile $ImagePath
[System.Windows.Forms.SystemInformation]::SetWallpaper($ImagePath)

# Set Password Restriction 
Function Validate-Password {
    param(
        [string]$Password
    )

    if ($Password.Length -lt 8 -or -not $Password -cmatch "[A-Z]" -or -not $Password -cmatch "[!@#\$%^&*()]") {
        Write-Host "Invalid password. It must be at least 8 characters long, contain an uppercase letter, and a special symbol."
        return $false
    }

    return $true
}

# Password Validation
$Password = Read-Host "Enter a password"
if (Validate-Password -Password $Password) {
    Write-Host "Password is valid."
} else {
    Write-Host "Password is not valid."
}
