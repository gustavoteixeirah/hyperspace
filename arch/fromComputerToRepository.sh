#!/usr/bin/bash

cp -v ~/.xinitrc ~/repositories/hyperspace/dotfiles/.xinitrc
cp -v ~/.zshrc ~/repositories/hyperspace/dotfiles/.zshrc

cp -v ~/.config/polybar/* ~/repositories/hyperspace/dotfiles/polybar/
cp -v ~/.config/i3/* ~/repositories/hyperspace/dotfiles/i3/
# cp -v ~/.config/screenlayout/* ~/hyperspace/dotfiles/screenlayout/
cp -v ~/.config/fontconfig/* ~/repositories/hyperspace/dotfiles/fontconfig/
cp -v ~/Pictures/* ~/repositories/hyperspace/pictures/
cp -v ~/.oh-my-zsh/custom/themes/* ~/repositories/hyperspace/oh-my-zsh-themes/