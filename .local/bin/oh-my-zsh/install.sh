#!/usr/bin/env bash
set -e

config_folder="${XDG_CONFIG_HOME:-$HOME/.config}"
oh_my_zsh_folder="${config_folder}/oh-my-zsh"
ZSH="${oh_my_zsh_folder}" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

ZSH_CUSTOM="${ZSH_CUSTOM:-$oh_my_zsh_folder/custom}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"

yay -S --needed --removemake --nocleanmenu --nodiffmenu --noeditmenu --noconfirm \
    ttf-meslo-nerd-font-powerlevel10k

# https://python-poetry.org/docs/#enable-tab-completion-for-bash-fish-or-zsh
# https://github.com/python-poetry/poetry/issues/1734
mkdir -p "${ZSH_CUSTOM}/plugins/poetry"
poetry completions zsh > "${ZSH_CUSTOM}/plugins/poetry/_poetry"

# Should not be needed, cause the .zshrc file will be copied from this repo
# search_value='ZSH_THEME=\"robbyrussell\"'
# replace_value='ZSH_THEME=\"powerlevel10k\/powerlevel10k\"'
# sed -i "s/${search_value}/${replace_value}/g" "${ZDOTDIR}/.zshrc"
