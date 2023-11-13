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
# The command to set the background depends on the desktop environment
# For GNOME, use:
gsettings set org.gnome.desktop.background picture-uri "file:///home/$username/background.jpg"

# Set Chrome as the default browser
# The actual implementation can vary depending on the desktop environment
update-alternatives --set x-www-browser /usr/bin/google-chrome-stable

# Add Chrome, Slack, and Zoom to favorites in the dock
# This depends on the desktop environment. For GNOME with dconf:
gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'slack.desktop', 'zoom.desktop']"

# Create a one-time login script for the user
cat > /home/$username/first-login.sh <<EOL
#!/bin/bash
zenity --info --text="Please change your password immediately after logging in for the first time."
passwd
rm -- "\$0"
EOL

chmod +x /home/$username/first-login.sh
echo "/home/$username/first-login.sh" >> /home/$username/.profile

# Ensure correct ownership of the files
chown $username:$username /home/$username/first-login.sh
chown $username:$username /home/$username/.profile
