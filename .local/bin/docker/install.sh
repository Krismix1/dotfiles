#!/usr/bin/env bash
set -e

sudo pacman -S --noconfirm --needed \
                docker \
                docker-buildx \
                docker-compose

yay -S --needed --removemake --nocleanmenu --nodiffmenu --noeditmenu --noconfirm \
                lazydocker

sudo systemctl enable --now docker.service
sudo groupadd docker
sudo usermod -aG docker $USER

# Optional - Configure data directory
# sudo mkdir /etc/docker
# sudo touch /etc/docker/daemon.json
# echo {
#   "data-root": "/path/to/your/new/docker/root"
# } >> /etc/docker/daemon.json
