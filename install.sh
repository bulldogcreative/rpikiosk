#!/bin/bash

source ~/.env

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
