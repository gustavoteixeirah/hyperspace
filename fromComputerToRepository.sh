#!/usr/bin/bash

cp -v ~/.xinitrc ~/repositories/my-arch/dotfiles/.xinitrc
cp -v ~/.zshrc ~/repositories/my-arch/dotfiles/.zshrc

cp -v ~/.config/polybar/* ~/repositories/my-arch/dotfiles/polybar/
cp -v ~/.config/i3/* ~/repositories/my-arch/dotfiles/i3/
# cp -v ~/.config/screenlayout/* ~/my-arch/dotfiles/screenlayout/
cp -v ~/.config/fontconfig/* ~/repositories/my-arch/dotfiles/fontconfig/
cp -v ~/Pictures/* ~/repositories/my-arch/pictures/
cp -v ~/.oh-my-zsh/custom/themes/* ~/repositories/my-arch/oh-my-zsh-themes/