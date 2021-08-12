# Xorg
sudo pacman -S --noconfirm xorg xorg-xinit xorg-prop xorg-xrandr
cp /etc/X11/xinit/xinitrc .xinitrc

# Fonts
sudo pacman -S --noconfirm firefox dina-font tamsyn-font bdf-unifont ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid gnu-free-fonts ttf-ibm-plex ttf-liberation ttf-linux-libertine noto-fonts ttf-roboto tex-gyre-fonts ttf-ubuntu-font-family ttf-anonymous-pro ttf-cascadia-code ttf-fantasque-sans-mono ttf-fira-mono ttf-hack ttf-fira-code ttf-inconsolata ttf-jetbrains-mono ttf-monofur adobe-source-code-pro-fonts cantarell-fonts inter-font ttf-opensans gentium-plus-font ttf-junicode adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts noto-fonts-cjk noto-fonts-emoji

# Wallpaper
sudo pacman -S nitrogen

# Audio
sudo pacman -S pulseaudio pulseaudio-alsa pavucontrol
yay spotify

# Tools
sudo pacman -S curl wget

# Development tools
yay archlinux-java
sudo pacman -S jdk11-openjdk jdk8-openjdk maven
# git clone https://aur.archlinux.org/brave-bin.git
# cd brave-bin
# makepkg -si

# yay visual-studio-code-bin

# setxkbmap br

