!/usr/bin/bash

declare -a aurpackages=(
"visual-studio-code-bin"
"postman-bin"
"slack-desktop"
"kind"
"jetbrains-toolbox"
)
for x in "${aurpackages[@]}"; do
    yay --noconfirm --needed -S "$x"
done

# General tools
sudo pacman --noconfirm --needed -S ufw curl wget zip unzip tree neofetch btop obsidian openssh

# Java related tools
sudo pacman --noconfirm --needed -S java-runtime-common jdk17-openjdk maven gradle

# Fonts
sudo pacman --noconfirm --needed -S ttf-fira-code noto-fonts noto-fonts-emoji ttf-dejavu

# Frontend related
sudo pacman --noconfirm --needed -S nodejs npm pnpm

# Python related
# sudo pacman --noconfirm --needed -S tk python-pip python-ipykernel python-minio jupyterlab jupyter-notebook cuda tensorflow-cuda python-tensorflow-cuda pyenv

# Database related
# sudo pacman --noconfirm --needed -S postgresql

# Infra tools
sudo pacman --noconfirm --needed -S docker docker-compose kubectl
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker "$USER"
newgrp docker

