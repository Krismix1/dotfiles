#!/usr/bin/env bash
# https://forums.linuxmint.com/viewtopic.php?t=159064

sudo pacman -S --noconfirm --needed xorg-util-macros
git clone git://anongit.freedesktop.org/xorg/app/xrandr
# Manual for now:
# Go to line 2886
# Change the if statement from "if (sx != 1 || sy != 1)" to "if ((sx != 1 || sy != 1) && (sx != 0.5 || sy != 0.5))"
pushd xrandr
./autoconf.sh
make
popd
