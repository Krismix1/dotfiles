#!/usr/bin/env bash
set -e

sudo pacman -S --noconfirm --needed \
                firefox \
                networkmanager-openconnect

yay -S --needed --removemake --nocleanmenu --nodiffmenu --noeditmenu --noconfirm \
                google-chrome \
                google-cloud-sdk \
                quickredis \
                teams
