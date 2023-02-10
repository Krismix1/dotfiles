#!/usr/bin/env bash
scrot /tmp/screen.png
cp -r ~/.config/lockscreens /tmp
convert /tmp/screen.png -scale 10% -scale 1000% /tmp/lockscreens/screen.png
image=$(ls /tmp/lockscreens/* | sort -R | tail -n 1)
i3lock -i "$image"
rm /tmp/screen.png
