#!/bin/bash

# Ask for the new username
read -p "Enter the new username: " username

# Create new user without sudo permissions
adduser --disabled-password --gecos "" $username

# Set password for the new user
echo "Set password for the new user:"
passwd $username

# Download and set the background image
bg_url="https://raw.githubusercontent.com/avalon-lake-tech/mrbeast-scripts/main/avalonlake-desktop.png"
wget $bg_url -O /home/$username/background.jpg

# Create a one-time login script for the user
cat > /home/$username/first-login.sh <<EOL
#!/bin/bash
# Set the background in GNOME for the new user
DISPLAY=:0 GSETTINGS_BACKEND=dconf gsettings set org.gnome.desktop.background picture-uri "file:///home/$username/background.jpg"

# Set Chrome as the default browser for the new user
xdg-settings set default-web-browser google-chrome.desktop

# Prompt for password change
zenity --info --text="Please change your password immediately after logging in for the first time."
passwd

# Confirmation message to show that the script ran
zenity --info --text="Initial setup complete. Welcome to your new account!"

# Remove this script
rm -- "\$0"
EOL

chmod +x /home/$username/first-login.sh
echo "/home/$username/first-login.sh" >> /home/$username/.profile

# Modify favorites in the GNOME dock for the new user
# This step still needs to be done by the current user as it affects the system setting
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'yelp.desktop', 'trash:///', 'google-chrome.desktop', 'slack.desktop', 'zoom.desktop']"

# Ensure correct ownership of the files
chown $username:$username /home/$username/first-login.sh /home/$username/.profile /home/$username/background.jpg
