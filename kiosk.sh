#!/bin/bash

# Get our environment variables
source ~/.env

# Screen settings
xset s noblank
xset s off
xset -dpms

# Start unclutter
unclutter -idle 0.5 -root &

# Adjust Chromium settings
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/pi/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/pi/.config/chromium/Default/Preferences

/usr/bin/chromium-browser --noerrdialogs --disable-infobars --kiosk $KIOSK_URL &
