#!/bin/bash

# Run apt update before anything else.
sudo apt update -y

source ~/.env

if [[ -z $PI_HOSTNAME ]]; then
    echo "Skipping hostname"
else
    sudo su -c 'source /home/pi/.env ; echo "127.0.0.1    $PI_HOSTNAME" >> /etc/hosts'
    sudo hostnamectl set-hostname ${PI_HOSTNAME}
fi

sudo apt-get purge bluez -y
sudo apt-get autoremove -y

echo "PLEASE REBOOT NOW"
