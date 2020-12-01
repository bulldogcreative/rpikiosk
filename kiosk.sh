#!/bin/bash

# Get our environment variables
source ~/.env

# Screen settings
xset s noblank
xset s off
xset -dpms

# Adjust Chromium settings
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/pi/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/pi/.config/chromium/Default/Preferences
