!/usr/bin/bash

sudo pacman --noconfirm --needed -S xorg xorg-server xorg-xinit xorg-xprop xorg-xrandr nvidia nvidia-utils nvidia-settings


sudo pacman --noconfirm --needed -S i3 

sudo cp ~/dotfiles/.xinitrc ~/.xinitrc

# Tools
sudo pacman --noconfirm --needed -S vim git base-devel rofi feh curl wget zip unzip zsh

git config --global user.email "contact@gustavoteixeira.dev"
git config --global user.name "Gustavo Teixeira"

chsh -s `which zsh`

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~
yay --noconfirm --needed -S google-chrome
yay --noconfirm --needed -S spotify