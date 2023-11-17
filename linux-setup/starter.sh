#!/bin/bash

#Downloads User script.
wget https://raw.githubusercontent.com/avalon-lake-tech/mrbeast-scripts/main/linux-setup/linux-user-script.sh

#Downloads Veeam Linux Client
wget https://raw.githubusercontent.com/avalon-lake-tech/mrbeast-scripts/main/linux-setup/veeam-release-deb_1.0.8_amd64.deb
wget https://raw.githubusercontent.com/avalon-lake-tech/mrbeast-scripts/main/linux-setup/anydesk_6.3.0-1_amd64.deb

#Install Veeam
sudo apt install ./veeam* -y
sudo apt install blksnap -y
sudo apt install veeam
sudo apt install ./anydesk* -y
