/# First
pacman -S --noconfirm xorg xorg-xinit xorg-xprop xorg-xrandr xorg-server nvidia nvidia-utils nvidia-settings base-devel
cp /etc/X11/xinit/xinitrc .xinitrc

# Second
sudo pacman -S i3-gaps i3status dmenu picom firefox terminator git feh pulseaudio pulseaudio-alsa pavucontrol 
 vim .xinitrc
 delete last five lines
 append "exec i3"
 
 
 # Polybar
 sudo pacman -S xorg-fonts-misc
 yay -S siji-git ttf-unifont
 yay polybar
 mkdir .config/polybar
 # TODO: Trocar pela minha config
 sudo cp /usr/share/doc/polybar/config ~/.config/polybar/
 sudo chown teixeira:users .config/polybar/config
 
 # TODO criar script para https://github.com/polybar/polybar/wiki#launching-the-bar-in-your-wms-bootstrap-routine
 # https://github.com/polybar/polybar/wiki#launching-the-bar-in-your-wms-bootstrap-routine
 sudo chmod +x .config/polybar/launch.sh

 yay archlinux-java spotify visual-studio-code-bin
sudo pacman -S jdk11-openjdk jdk8-openjdk maven

 # Resolution tool
sudo pacman -S arandr

sudo chmod +x .config/screenlayout/dualmonitor.sh

 Verificar...
 https://github.com/loeken/dotfiles/blob/master/i3/config



# Fonts
sudo pacman -S --noconfirm firefox dina-font tamsyn-font bdf-unifont ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid gnu-free-fonts ttf-ibm-plex ttf-liberation ttf-linux-libertine noto-fonts ttf-roboto tex-gyre-fonts ttf-ubuntu-font-family ttf-anonymous-pro ttf-cascadia-code ttf-fantasque-sans-mono ttf-fira-mono ttf-hack ttf-fira-code ttf-inconsolata ttf-jetbrains-mono ttf-monofur adobe-source-code-pro-fonts cantarell-fonts inter-font ttf-opensans gentium-plus-font ttf-junicode adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts noto-fonts-cjk noto-fonts-emoji

# Wallpaper
sudo pacman -S nitrogen

# Audio
sudo pacman -S pulseaudio pulseaudio-alsa pavucontrol
yay spotify

# Tools
sudo pacman -S curl wget zip unzip

# Development tools
yay archlinux-java
sudo pacman -S jdk11-openjdk jdk8-openjdk maven
# git clone https://aur.archlinux.org/brave-bin.git
# cd brave-bin
# makepkg -si

# yay visual-studio-code-bin

# setxkbmap br

