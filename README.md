# kiosk

## Usage

1. Change password
1. Copy `.env.example` to `~/.env`
1. Edit `~/.env`
1. Run `install.sh`
1. Close Chromium
1. Reboot

## Faq

Q. It opens open the browser and tries to go to "REPLACE_ME"

You need to edit `/lib/systemd/system/kiosk.service` and change `REPLACE_ME`
with the real URL.

Run `systemctl daemon-reload`

Reboot.
