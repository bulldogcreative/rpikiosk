#!/bin/bash

source ~/.env

#  .d8888b.   .d8888b.  888    888
# d88P  Y88b d88P  Y88b 888    888
# Y88b.      Y88b.      888    888
#  "Y888b.    "Y888b.   8888888888
#     "Y88b.     "Y88b. 888    888
#       "888       "888 888    888
# Y88b  d88P Y88b  d88P 888    888
#  "Y8888P"   "Y8888P"  888    888
#
# SSH is disabled by default.

# Secure Pi
mkdir ~/.ssh
chmod 755 ~/.ssh

if [[ -f "~/.ssh/authorized_keys" ]]; then
    echo "Authorized Keys already exists"
else
    touch ~/.ssh/authorized_keys
    chmod 644 ~/.ssh/authorized_keys
    wget https://gist.githubusercontent.com/levidurfee/76af5d335d98a34c7453d0ab037de272/raw/8263cbfab8fc37434ea797173340f927129b783b/authorized_keys -O ~/.ssh/authorized_keys
fi

# Disable SSH password authentication
sudo sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

# Remove software
sudo apt purge wolfram-engine scratch scratch2 nuscratch sonic-pi idle3 -y
sudo apt purge smartsim java-common minecraft-pi libreoffice* -y

# Clean up
sudo apt clean
sudo apt autoremove -y

# Update remaining software
sudo apt update -y
sudo apt upgrade -y

# Install unclutter (hides point pointer)
sudo apt install unclutter -y

# Install Stream editor
sudo apt install sed -y

# Enable VNC service
sudo systemctl enable vncserver-x11-serviced.service

# Start VNC service
sudo systemctl start vncserver-x11-serviced.service

# 888    d8P  d8b                   888
# 888   d8P   Y8P                   888
# 888  d8P                          888
# 888d88K     888  .d88b.  .d8888b  888  888
# 8888888b    888 d88""88b 88K      888 .88P
# 888  Y88b   888 888  888 "Y8888b. 888888K
# 888   Y88b  888 Y88..88P      X88 888 "88b
# 888    Y88b 888  "Y88P"   88888P' 888  888

# Customize the service file with the kiosk url
envsubst < ./services/kiosk.service > ./kiosk.service

# Create service
sudo cp ./services/unclutter.service /lib/systemd/system/unclutter.service
sudo cp ./kiosk.service /lib/systemd/system/kiosk.service

# Enable the new service
sudo systemctl daemon-reload
sudo systemctl enable unclutter.service
sudo systemctl enable kiosk.service

# Copy script to home folder
cp ./scripts/kiosk.sh ~/

# Open chromium so it creates default settings in `~/.config`
/usr/bin/chromium-browser
