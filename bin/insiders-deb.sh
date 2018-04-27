#!/bin/bash
echo "$(whoami)"
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

wget "https://vscode-update.azurewebsites.net/latest/linux-deb-x64/insider" -O /tmp/code_latest_amd64.deb
sudo dpkg -i /tmp/code_latest_amd64.deb
sudo rm /tmp/code_latest_amd64.deb
