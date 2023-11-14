#!/bin/bash

# Ask for the new username
read -p "Enter the new username: " username
default_password="solarwinds123" # Set your default password here

# Create new user without sudo permissions
adduser --disabled-password --gecos "" $username
echo "$username:$default_password" | chpasswd

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

# Configure the dock for the new user
gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'thunderbird.desktop', 'org.gnome.Nautilus.desktop', 'yelp.desktop', 'org.gnome.Nautilus.desktop trash:///']"

# Prompt for password change and display a welcome message
zenity --info --text="Welcome to your new account! Please change your password."
passwd
rm -- "\$0"
EOL

chmod +x /home/$username/first-login.sh
echo "/home/$username/first-login.sh" >> /home/$username/.profile

# Ensure correct ownership of the files
chown $username:$username /home/$username/first-login.sh /home/$username/.profile /home/$username/background.jpg
