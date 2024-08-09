#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
sed -i 's@Exec=waydroid first-launch@Exec=/usr/bin/waydroid-launcher first-launch@g' /usr/share/applications/Waydroid.desktop