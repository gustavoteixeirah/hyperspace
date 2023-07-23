#!/usr/bin/bash

# sudo pacman --noconfirm --needed -S gnome-terminal docker docker-compose nodejs npm nvidia nvidia-utils nvidia-settings noto-fonts noto-fonts-emoji ttf-dejavu ttf-fira-code curl wget zip unzip zsh zsh-completions neofetch


# Declare AUR Packages
declare -a aurpackages=(
"slack-desktop"
"ttf-unifont"
"siji-git"
"ttf-symbola"
"spotify"
"gotop"
)

for x in "${aurpackages[@]}"; do
    yay --noconfirm --needed -S "$x"
done