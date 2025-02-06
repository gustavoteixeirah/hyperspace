<<<<<<< HEAD
sudo pacman --noconfirm --needed -S xorg xorg-server xorg-xinit xorg-xprop xorg-xrandr arandr xorg-fonts-misc rofi feh pavucontrol 
# sudo pacman --noconfirm --needed -S nvidia-lts  
sudo pacman --noconfirm --needed -S i3 
sudo cp ~/code/hyperspace/dotfiles/.xinitrc ~/.xinitrc
sudo mkdir -p ~/.local/share/fonts
sudo cp ~/code/hyperspace/fonts/* ~/.local/share/fonts
fc-cache

#sudo pacman --noconfirm --needed -S xorg xorg-server xorg-xinit xorg-xprop xorg-xrandr arandr xorg-fonts-misc rofi feh pavucontrol 
# sudo pacman --noconfirm --needed -S nvidia-lts  
#sudo pacman --noconfirm --needed -S i3 
#sudo cp ~/code/hyperspace/dotfiles/.xinitrc ~/.xinitrc
#sudo mkdir -p ~/.local/share/fonts
#sudo cp ~/code/hyperspace/fonts/* ~/.local/share/fonts
#fc-cache

#Install st
cd ~/code/hyperspace/arch/suckless/st || exit
sudo make install
cd ~ || exit
# Tools
sudo pacman --noconfirm --needed -S base-devel rofi feh curl wget zip unzip zsh zsh-completions neofetch ranger fzf zoxide
# Fonts
sudo pacman --noconfirm --needed -S noto-fonts noto-fonts-emoji ttf-dejavu ttf-fira-code 
# Audio
sudo pacman --noconfirm --needed -S pulseaudio pavucontrol
chsh -s `which zsh`
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~
yay --noconfirm --needed -S google-chrome
zsh --version
