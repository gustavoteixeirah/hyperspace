#!/usr/bin/env bash
# i3: Caps Lock = $mod, Win+Enter = terminal rápido, gaps, sem bordas, wallpaper, PrintScreen = flameshot
# Uso: bash ~/code/hyperspace/6_i3.sh   (pode rodar de novo sem problema)
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ts="$(date +%Y%m%d%H%M%S)"

# flameshot: PrintScreen = print recortando área
sudo pacman -S --needed --noconfirm flameshot
# abre sem área pré-selecionada (clicar e arrastar), em vez de lembrar a última região
fs_ini="$HOME/.config/flameshot/flameshot.ini"
mkdir -p "$(dirname "$fs_ini")"
if grep -q '^saveLastRegion=' "$fs_ini" 2>/dev/null; then
  sed -i 's/^saveLastRegion=.*/saveLastRegion=false/' "$fs_ini"
elif grep -q '^\[General\]' "$fs_ini" 2>/dev/null; then
  sed -i '/^\[General\]/a saveLastRegion=false' "$fs_ini"
else
  printf '[General]\nsaveLastRegion=false\n' >> "$fs_ini"
fi

mkdir -p "$HOME/.config/i3/config.d" "$HOME/.local/bin"
[[ -f "$HOME/.config/i3/config" ]] && cp "$HOME/.config/i3/config" "$HOME/.config/i3/config.bak-$ts"
cp -v "$REPO/dotfiles/i3/config" "$HOME/.config/i3/config"
install -v -m 755 "$REPO/dotfiles/bin/wallpaper" "$HOME/.local/bin/wallpaper"
for f in keyboard-setup input-watch; do install -v -m 755 "$REPO/dotfiles/bin/$f" "$HOME/.local/bin/$f"; done

i3 -C -c "$HOME/.config/i3/config"
# restart (não reload) para rodar os exec_always (Caps Lock, wallpaper); mantém as janelas
if pgrep -x i3 >/dev/null; then i3-msg restart >/dev/null || true; echo "i3 reiniciado."; fi
echo "Pronto! Coisas só desta máquina vão em ~/.config/i3/config.d/*.conf"
