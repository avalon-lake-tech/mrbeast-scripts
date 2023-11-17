#!/bin/bash

username=$(whoami)

#Setup background
wget https://raw.githubusercontent.com/avalon-lake-tech/mrbeast-scripts/main/avalonlake-desktop.png -O /home/$username/background.jpg
gsettings set org.gnome.desktop.background picture-uri "file:///home/$username/background.jpg"

#Downloads User script.
wget https://raw.githubusercontent.com/avalon-lake-tech/mrbeast-scripts/main/linux-setup/linux-user-script.sh

#Downloads Veeam Linux Client
#wget https://raw.githubusercontent.com/avalon-lake-tech/mrbeast-scripts/main/linux-setup/veeam-release-deb_1.0.8_amd64.deb


#Download AnyDesk
wget https://raw.githubusercontent.com/avalon-lake-tech/mrbeast-scripts/main/linux-setup/anydesk_6.3.0-1_amd64.deb

#Install Veeam. Preinstalled for Demo.
#sudo apt install ./veeam* -y
#sudo apt update -y
#sudo apt install blksnap -y
#sudo apt install veeam -y

#Install AnyDesk
sudo apt install ./anydesk* -y

#Install sshfs
sudo apt install sshfs -y

#Modify the GMD config to remove Wayland display. This is for AnyDesk access. 
sudo sed -i 's/#WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/custom.conf

#Setting up the mount sshfs fileserver
sudo sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf
sudo mkdir -p /mnt/fileserver 
sudo chown $username:root /mnt/fileserver
sudo chmod 770 /mnt/fileserver
sudo sshfs -o allow_other avalonlakebackups@54.83.52.177:/home/avalonlakebackups/backups /mnt/fileserver
