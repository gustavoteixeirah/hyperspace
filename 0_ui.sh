!/usr/bin/bash

sudo pacman --noconfirm --needed -S xorg xorg-server xorg-xinit xorg-xprop xorg-xrandr nvidia-lts

sudo pacman --noconfirm --needed -S i3 

sudo cp ~/code/hyperspace/dotfiles/.xinitrc ~/.xinitrc

# Tools
sudo pacman --noconfirm --needed -S vim git base-devel rofi feh curl wget zip unzip zsh

chsh -s `which zsh`

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~
yay --noconfirm --needed -S google-chrome
yay --noconfirm --needed -S spotify
