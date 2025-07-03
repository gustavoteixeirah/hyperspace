!/usr/bin/bash

declare -a aurpackages=(
"visual-studio-code-bin"
"postman-bin"
"kind"
"jetbrains-toolbox"
"slack-desktop"
"drawio-desktop"
)
for x in "${aurpackages[@]}"; do
    yay --noconfirm --needed -S "$x"
done

# General tools
sudo pacman --noconfirm --needed -S ufw tmux curl wget zip unzip tree jq btop obsidian openssh zoxide fd keepass lsd bat flameshot 
sudo pacman -S openssl readline zlib curl libutil-linux icu


# Neovim dependencies
sudo pacman --noconfirm --needed -S ripgrep xclip xsel lua-language-server

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#sudo pacman --noconfirm --needed -S java-runtime-common jdk17-openjdk maven gradle

# Fonts
#sudo pacman --noconfirm --needed -S ttf-fira-code noto-fonts noto-fonts-emoji ttf-dejavu

# Frontend related
#sudo pacman --noconfirm --needed -S nvm nodejs npm pnpm 
# Frontend related
# sudo pacman --noconfirm --needed -S nvm nodejs npm pnpm 

# Python related
# sudo pacman --noconfirm --needed -S tk python-pip python-ipykernel python-minio jupyterlab jupyter-notebook cuda tensorflow-cuda python-tensorflow-cuda pyenv ruff
# curl -LsSf https://astral.sh/uv/install.sh | sh

# Rust related
# jsudo pacman --noconfirm --needed -S rustup 
# rustup default stable

# Database related
# sudo pacman --noconfirm --needed -S postgresql

# Infra tools
sudo pacman --noconfirm --needed -S docker docker-compose docker-buildx kubectl
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker "$USER"
newgrp docker

#curl -s "https://get.sdkman.io" | bash
#source "$HOME/.sdkman/bin/sdkman-init.sh"

sudo pacman -S $(pacman -Sgq nerd-fonts)

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
