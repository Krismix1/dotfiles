#!/usr/bin/env bash
set -e

yay -S --needed --removemake --nocleanmenu --nodiffmenu --noeditmenu --noconfirm \
                visual-studio-code-bin

# Install packages
# https://unix.stackexchange.com/a/580545
while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    code --install-extension "${LINE}"
done < extensions.txt
