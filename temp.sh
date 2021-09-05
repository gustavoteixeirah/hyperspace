#!/usr/bin/bash

mkdir ~/Downloads || echo "skipping creating new Downloads directory"

cd ~/Downloads || exit

git clone https://aur.archlinux.org/paru.git

cd paru || exit

makepkg -si
