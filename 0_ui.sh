sudo pacman --noconfirm --needed -S arandr rofi feh pavucontrol base-devel curl wget zip unzip zsh zsh-completions fzf ttf-fira-code ghostty xcape i3status
chsh -s `which zsh`
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~
yay --noconfirm --needed -S zen-browser-bin google-chrome
zsh --version
