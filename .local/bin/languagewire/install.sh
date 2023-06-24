#!/usr/bin/env bash
set -e

sudo pacman -S --noconfirm --needed \
                firefox \
                helm \
                networkmanager-openconnect

yay -S --needed --removemake --nocleanmenu --nodiffmenu --noeditmenu --noconfirm \
                google-chrome \
                google-cloud-sdk \
                google-cloud-sdk-gke-gcloud-auth-plugin \
                microsoft-edge-stable-bin \
                quickredis

