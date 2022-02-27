#!/usr/bin/env bash
scrot /tmp/screen.png
convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png
# python get_dad_joke.py
i3lock -i /tmp/screen.png
rm /tmp/screen.png
