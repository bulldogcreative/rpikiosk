#!/bin/bash

RC="sudo raspi-config nonint"

${RC} do_configure_keyboard us
${RC} do_change_timezone America/New_York
${RC} do_change_locale LANG=en_US.UTF-8

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
    # https://raspberrypi.stackexchange.com/a/9900
    sudo su -c 'source /home/pi/.env ; echo "127.0.0.1    $PI_HOSTNAME" >> /etc/hosts'
    ${RC} do_hostname ${PI_HOSTNAME}
fi

# 888       888 d8b 8888888888 d8b
# 888   o   888 Y8P 888        Y8P
# 888  d8b  888     888
# 888 d888b 888 888 8888888    888
# 888d88888b888 888 888        888
# 88888P Y88888 888 888        888
# 8888P   Y8888 888 888        888
# 888P     Y888 888 888        888

#envsubst < ./configs/wpa_supplicant.conf >> ./wpa_supplicant.conf
#sudo su -c "cat ./wpa_supplicant.conf >> /etc/wpa_supplicant/wpa_supplicant.conf"
${RC} do_wifi_ssid_passphrase ${WIFI_SSID} ${WIFI_PSK}

echo "PLEASE REBOOT NOW"
