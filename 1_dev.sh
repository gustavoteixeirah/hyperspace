!/usr/bin/bash

declare -a aurpackages=(
"visual-studio-code-bin"
"zen-browser-bin"
"cursor-bin"
"postman-bin"
"kind"
"jetbrains-toolbox"
"drawio-desktop"
)
for x in "${aurpackages[@]}"; do
    yay --noconfirm --needed -S "$x"
done

# General tools
sudo pacman --noconfirm --needed -S ufw tmux curl wget zip unzip tree jq btop openssh fd keepass lsd bat flameshot 
sudo pacman -S openssl readline zlib curl libutil-linux icu

yay -S --noconfirm --needed \
  brightnessctl playerctl pamixer pavucontrol wireplumber \
  fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool \
  nautilus sushi ffmpegthumbnailer \
  mpv evince imv

# Install bluetooth controls
yay -S --noconfirm --needed blueberry

# Turn on bluetooth by default
sudo systemctl enable --now bluetooth.service

yay -S --noconfirm power-profiles-daemon

yay -S --noconfirm --needed libreoffice obs-studio

yay -S --noconfirm --needed pinta ||
  echo -e "\e[31mFailed to install Pinta. Continuing without!\e[0m"

yay -S --noconfirm --needed spotify dropbox-cli 1password-beta 1password-cli ||
  echo -e "\e[31mFailed to install Spotify, Dropbox, and/or 1password because of a keyserver problem. Continuing without!\e[0m"

yay -S --noconfirm --needed \
  cargo clang llvm mise \
  imagemagick \
  mariadb-libs postgresql-libs \
  github-cli \
  lazygit lazydocker-bin


# Neovim dependencies
sudo pacman --noconfirm --needed -S ripgrep xclip xsel lua-language-server
# Python related
sudo pacman --noconfirm --needed -S cuda

# Infra tools
sudo pacman --noconfirm --needed -S docker docker-compose docker-buildx kubectl
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker "$USER"
newgrp docker

sudo pacman -S $(pacman -Sgq nerd-fonts)

