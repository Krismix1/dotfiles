#!/usr/bin/env bash
set -e

sudo pacman -S --noconfirm --needed \
                docker \
                docker-compose

sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo groupadd docker
sudo usermod -aG docker $USER
