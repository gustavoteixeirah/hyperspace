#!/usr/bin/env bash
# Terminal: zsh + oh-my-zsh + plugins + powerlevel10k + ghostty
# Uso: bash ~/code/hyperspace/5_terminal.sh   (pode rodar de novo sem problema)
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo pacman --noconfirm --needed -S zsh git curl fzf ghostty

# oh-my-zsh (sem trocar de shell nem sobrescrever o .zshrc)
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
clone() {
  if [[ -d "$2/.git" ]]; then git -C "$2" pull -q --ff-only; else git clone -q --depth 1 "$1" "$2"; fi
}

clone https://github.com/zsh-users/zsh-autosuggestions          "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting      "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
clone https://github.com/romkatv/powerlevel10k                  "$ZSH_CUSTOM/themes/powerlevel10k"

# dotfiles (faz backup do que já existir)
ts="$(date +%Y%m%d%H%M%S)"
for f in .zshrc .p10k.zsh; do
  [[ -f "$HOME/$f" ]] && cp "$HOME/$f" "$HOME/$f.bak-$ts"
  cp -v "$REPO/dotfiles/zsh/$f" "$HOME/$f"
done
mkdir -p "$HOME/.config/ghostty"
f="$HOME/.config/ghostty/config.ghostty"
[[ -f "$f" ]] && cp "$f" "$f.bak-$ts"
cp -v "$REPO/dotfiles/ghostty/config.ghostty" "$f"

touch "$HOME/.zshrc.local"   # coloque segredos/variáveis da máquina aqui

[[ "$(getent passwd "$USER" | cut -d: -f7)" == "$(command -v zsh)" ]] || chsh -s "$(command -v zsh)"

echo "Pronto! Abra um terminal novo (ou rode: exec zsh)."
