#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]] || [[ ! -f /etc/arch-release ]]; then
  echo "Este script foi feito para Arch Linux."
  exit 1
fi

if [[ "$(id -u)" -eq 0 ]]; then
  echo "Execute com usuário normal (sem root)."
  exit 1
fi

install_yay() {
  if command -v yay >/dev/null 2>&1; then
    return
  fi

  local tmp_dir
  tmp_dir="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"
  pushd "$tmp_dir/yay" >/dev/null
  makepkg -si --noconfirm
  popd >/dev/null
  rm -rf "$tmp_dir"
}

install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    return
  fi

  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

clone_or_pull() {
  local repo_url="$1"
  local dest_dir="$2"

  if [[ -d "$dest_dir/.git" ]]; then
    git -C "$dest_dir" pull --ff-only
  else
    git clone "$repo_url" "$dest_dir"
  fi
}

echo "==> Atualizando pacotes base"
sudo pacman -Syu --noconfirm

echo "==> Instalando pacotes oficiais (AMD iGPU, sem NVIDIA/CUDA)"
sudo pacman --noconfirm --needed -S \
  arandr rofi feh pavucontrol base-devel curl wget zip unzip zsh zsh-completions fzf \
  ttf-fira-code noto-fonts noto-fonts-emoji ttf-dejavu \
  ufw tmux tree jq btop openssh fd keepass lsd bat flameshot \
  brightnessctl playerctl wireplumber nautilus sushi ffmpegthumbnailer mpv evince imv \
  libreoffice obs-studio cargo clang llvm imagemagick mariadb-libs postgresql-libs \
  github-cli lazygit ripgrep xclip xsel lua-language-server \
  docker docker-compose docker-buildx kubectl \
  mesa vulkan-radeon libva-mesa-driver xf86-video-amdgpu

echo "==> Instalando yay"
install_yay

echo "==> Instalando pacotes AUR"
yay --noconfirm --needed -S \
  visual-studio-code-bin zen-browser-bin cursor-bin postman-bin kind \
  jetbrains-toolbox drawio-desktop google-chrome \
  fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool \
  lazydocker-bin pnpm

echo "==> Instalando pacotes AUR opcionais"
yay --noconfirm --needed -S \
  pinta spotify dropbox-cli 1password-beta 1password-cli || \
  echo "Alguns pacotes opcionais falharam, seguindo a instalação."

echo "==> Configurando Docker"
sudo systemctl enable --now docker.service
sudo usermod -aG docker "$USER"

echo "==> Configurando shell e plugins"
install_oh_my_zsh
clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
clone_or_pull https://github.com/zsh-users/zsh-autosuggestions.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
clone_or_pull https://github.com/zsh-users/zsh-completions.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions"
chsh -s "$(command -v zsh)" "$USER" || true

echo "==> Instalando mise e runtimes"
if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
fi

if ! grep -q "mise activate zsh" "$HOME/.zshrc" 2>/dev/null; then
  echo 'eval "$($HOME/.local/bin/mise activate zsh)"' >>"$HOME/.zshrc"
fi

"$HOME/.local/bin/mise" use -g python@3.11 java@21-openjdk node@22 uv maven gradle pnpm

echo "==> Finalizado. Reinicie a sessão para aplicar grupo docker e zsh padrão."
