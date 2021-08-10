#!/bin/bash

# Run apt update before anything else.
sudo apt update -y

source ~/.env

if [[ -z $PI_HOSTNAME ]]; then
    echo "Skipping hostname"
else
    sudo hostnamectl set-hostname ${PI_HOSTNAME}
fi

echo "PLEASE REBOOT NOW"
