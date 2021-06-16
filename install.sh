#!/bin/bash

# Run apt update before anything else.
sudo apt update -y

source ~/.env

# 888    888  .d88888b.   .d8888b. 88888888888
# 888    888 d88P" "Y88b d88P  Y88b    888
# 888    888 888     888 Y88b.         888
# 8888888888 888     888  "Y888b.      888
# 888    888 888     888     "Y88b.    888
# 888    888 888     888       "888    888
# 888    888 Y88b. .d88P Y88b  d88P    888
# 888    888  "Y88888P"   "Y8888P"     888

if [[ -z $PI_HOSTNAME ]]; then
    echo "Skipping hostname"
else
    sudo echo $PI_HOSTNAME > /etc/hostname
    sudo hostname $PI_HOSTNAME
    sudo echo "127.0.0.1    $PI_HOSTNAME" >> /etc/hosts
fi

# 888       888 d8b 8888888888 d8b
# 888   o   888 Y8P 888        Y8P
# 888  d8b  888     888
# 888 d888b 888 888 8888888    888
# 888d88888b888 888 888        888
# 88888P Y88888 888 888        888
# 8888P   Y8888 888 888        888
# 888P     Y888 888 888        888

envsubst < ./wpa_supplicant.conf >> /etc/wpa_supplicant/wpa_supplicant.conf

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
mkdir .ssh
chmod 755 .ssh

if [[ -f "~/.ssh/authorized_keys" ]]; then
    echo "Authorized Keys already exists"
else
    touch .ssh/authorized_keys
    chmod 644 .ssh/authorized_keys
    curl https://gist.githubusercontent.com/levidurfee/76af5d335d98a34c7453d0ab037de272/raw/8263cbfab8fc37434ea797173340f927129b783b/authorized_keys >> .ssh/authorized_keys
fi

# Disable SSH password authentication
sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

# 88888888888 d8b      888
#     888     Y8P      888
#     888              888
#     888     888  .d88888 888  888
#     888     888 d88" 888 888  888
#     888     888 888  888 888  888
#     888     888 Y88b 888 Y88b 888
#     888     888  "Y88888  "Y88888
#                               888
#                          Y8b d88P
#                           "Y88P"

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

# 888                       d8b
# 888                       Y8P
# 888
# 888      .d88b.   .d88b.  888 88888b.
# 888     d88""88b d88P"88b 888 888 "88b
# 888     888  888 888  888 888 888  888
# 888     Y88..88P Y88b 888 888 888  888
# 88888888 "Y88P"   "Y88888 888 888  888
#                       888
#                  Y8b d88P
#                   "Y88P"

# Auto login
# /etc/lightdm/lightdm.conf
# autologin-user=pi
# https://www.raspberrypi.org/forums/viewtopic.php?t=201604#p1254589

# 888     888 888b    888  .d8888b.
# 888     888 8888b   888 d88P  Y88b
# 888     888 88888b  888 888    888
# Y88b   d88P 888Y88b 888 888
#  Y88b d88P  888 Y88b888 888
#   Y88o88P   888  Y88888 888    888
#    Y888P    888   Y8888 Y88b  d88P
#     Y8P     888    Y888  "Y8888P"

if [[ -z $VNC_TOKEN ]]; then
    echo "Skipping VNC"
else
    # License
    # https://help.realvnc.com/hc/en-us/articles/360002253818
    sudo vnclicense -add $VNC_KEY

    # Join
    # https://help.realvnc.com/hc/en-us/articles/360002253818
    sudo vncserver-x11 -service -joinCloud $VNC_TOKEN
fi

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
envsubst < ./kiosk.service > ./kiosk.service

# Create service
sudo cp ./unclutter.service /lib/systemd/system/unclutter.service
sudo cp ./kiosk.service /lib/systemd/system/kiosk.service

# Enable the new service
sudo systemctl daemon-reload
sudo systemctl enable unclutter.service
sudo systemctl enable kiosk.service

# Start the new service
# It will start after a reboot, which we need to do anyway.
#sudo systemctl start kiosk.service

# Copy script to home folder
cp ./kiosk.sh ~/

# Open chromium so it creates default settings in `~/.config`
/usr/bin/chromium-browser
