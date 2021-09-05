#!/usr/bin/bash

# Check if the script is not being run as root user
if [ "$(id -u)" = 0]; then
    echo "You MUST NOT execute this script as the root user!"
    exit 1
fi

# Try to get fast servers to download packages
sudo pacman -Syy reflector
sudo reflector -c Brazil -a 8 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syyy


# Declare the packages to be installed with pacman
declare -a mypackages=(
"xorg"
"xorg-server"
"xorg-xinit"
"xorg-xprop"
"xorg-xrandr"
"xorg-fonts-misc"

"i3-gaps"
"picom"
"feh"

"pulseaudio"
"pulseaudio-alsa"
"pavucontrol"

"noto-fonts"
"noto-fonts-emoji"
"ttf-dejavu"
"ttf-fira-code"
)

for x in "${mypackages[@]}"; do
    sudo pacman -S --noconfirm --needed -S "$x"
done




# AUR Packages
#  libxft-bgra
#  ttf-symbola
#  siji-git
#  ttf-unifont


