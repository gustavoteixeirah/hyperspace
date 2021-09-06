#!/usr/bin/bash


sudo pacman --noconfirm --needed -S jdk11-openjdk jdk8-openjdk maven docker intellij-idea-community-edition

systemctl start docker.service
systemctl enable docker.service

sudo usermod -aG docker "$USER"
newgrp docker

# Declare AUR Packages
declare -a aurpackages=(
"archlinux-java"
"visual-studio-code-bin"
)

for x in "${aurpackages[@]}"; do
    paru --noconfirm --needed -S "$x"
done

