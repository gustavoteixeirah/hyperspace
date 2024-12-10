#!/usr/bin/env bash

# sudo pacman -S curl git
#
# git clone https://aur.archlinux.org/asdf-vm.git && cd asdf-vm && makepkg -si


asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin-add java https://github.com/halcyon/asdf-java.git
asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
asdf plugin-add python
asdf install python 3.12.0
asdf plugin add uv https://github.com/b1-luettje/asdf-uv.git
asdf global python 3.12.0
