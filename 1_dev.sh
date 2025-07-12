!/usr/bin/bash

declare -a aurpackages=(
"visual-studio-code-bin"
"zen-browser-bin"
"cursor-bin"
"postman-bin"
"kind"
"jetbrains-toolbox"
"drawio-desktop"
)
for x in "${aurpackages[@]}"; do
    yay --noconfirm --needed -S "$x"
done

# General tools
sudo pacman --noconfirm --needed -S ufw tmux curl wget zip unzip tree jq btop openssh fd keepass lsd bat flameshot 
sudo pacman -S openssl readline zlib curl libutil-linux icu


# Neovim dependencies
sudo pacman --noconfirm --needed -S ripgrep xclip xsel lua-language-server
# Python related
sudo pacman --noconfirm --needed -S cuda

# Infra tools
sudo pacman --noconfirm --needed -S docker docker-compose docker-buildx kubectl
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker "$USER"
newgrp docker

sudo pacman -S $(pacman -Sgq nerd-fonts)

