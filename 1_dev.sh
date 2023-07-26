!/usr/bin/bash

declare -a aurpackages=(
"visual-studio-code-bin"
"postman-bin"
"slack-desktop"
)
for x in "${aurpackages[@]}"; do
    yay --noconfirm --needed -S "$x"
done

# General tools
sudo pacman --noconfirm --needed -S curl wget zip unzip neofetch btop  obsidian

# IDEs
sudo pacman --noconfirm --needed -S intellij-idea-community-edition

# Java related tools
sudo pacman --noconfirm --needed -S java-runtime-common jdk8-openjdk jdk11-openjdk jdk17-openjdk maven gradle

# Fonts
sudo pacman --noconfirm --needed -S ttf-fira-code noto-fonts noto-fonts-emoji ttf-dejavu

# Frontend related
sudo pacman --noconfirm --needed -S nodejs npm pnpm

# Python related
sudo pacman --noconfirm --needed -S tk python-pip python-poetry
poetry config virtualenvs.in-project true

# Infra tools
sudo pacman --noconfirm --needed -S docker docker-compose 
systemctl start docker.service
systemctl enable docker.service
sudo usermod -aG docker "$USER"
newgrp docker

