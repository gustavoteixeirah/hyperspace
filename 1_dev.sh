!/usr/bin/bash

declare -a aurpackages=(
"visual-studio-code-bin"
"postman-bin"
"slack-desktop"
"kind"
"jetbrains-toolbox"
"drawio-desktop"
)
for x in "${aurpackages[@]}"; do
    yay --noconfirm --needed -S "$x"
done

# General tools
sudo pacman --noconfirm --needed -S ufw tmux curl wget zip unzip tree jq neofetch btop obsidian openssh stow zoxide fd keepass lsd bat discord flameshot 

# Neovim dependencies
sudo pacman --noconfirm --needed -S ripgrep xclip xsel

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#sudo pacman --noconfirm --needed -S java-runtime-common jdk17-openjdk maven gradle

# Fonts
sudo pacman --noconfirm --needed -S ttf-fira-code noto-fonts noto-fonts-emoji ttf-dejavu

# Frontend related
sudo pacman --noconfirm --needed -S nodejs npm pnpm

# Python related
# sudo pacman --noconfirm --needed -S tk python-pip python-ipykernel python-minio jupyterlab jupyter-notebook cuda tensorflow-cuda python-tensorflow-cuda pyenv ruff
curl -LsSf https://astral.sh/uv/install.sh | sh

# Rust related
sudo pacman --noconfirm --needed -S rustup 
rustup default stable

# Database related
# sudo pacman --noconfirm --needed -S postgresql

# Infra tools
sudo pacman --noconfirm --needed -S docker docker-compose docker-buildx kubectl
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker "$USER"
newgrp docker

curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
