!/usr/bin/bash

sudo pacman --noconfirm --needed -S xorg xorg-server xorg-xinit xorg-xprop xorg-xrandr arandr nvidia-lts

sudo pacman --noconfirm --needed -S i3 

sudo cp ~/code/hyperspace/dotfiles/.xinitrc ~/.xinitrc

#Install st
cd ~/code/hyperspace/arch/suckless/st || exit
sudo make install
cd ~ || exit

# Tools
sudo pacman --noconfirm --needed -S vim git base-devel rofi feh curl wget zip unzip zsh

sudo pacman --noconfirm --needed -S  noto-fonts noto-fonts-emoji ttf-dejavu ttf-fira-code


chsh -s `which zsh`

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~
yay --noconfirm --needed -S google-chrome

zsh --version

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

sudo cp -v ~/code/hyperspace/arch/dotfiles/.zshrc ~/.zshrc
sudo cp -v ~/code/hyperspace/arch/oh-my-zsh-themes/* ~/.oh-my-zsh/custom/themes/
