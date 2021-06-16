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

sudo reboot
