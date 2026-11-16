#!/usr/bin/env bash
# i3: Caps Lock = $mod, Win+Enter = terminal rápido, gaps, sem bordas, wallpaper
# Uso: bash ~/code/hyperspace/6_i3.sh   (pode rodar de novo sem problema)
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ts="$(date +%Y%m%d%H%M%S)"

mkdir -p "$HOME/.config/i3/config.d" "$HOME/.local/bin"
[[ -f "$HOME/.config/i3/config" ]] && cp "$HOME/.config/i3/config" "$HOME/.config/i3/config.bak-$ts"
cp -v "$REPO/dotfiles/i3/config" "$HOME/.config/i3/config"
install -v -m 755 "$REPO/dotfiles/bin/wallpaper" "$HOME/.local/bin/wallpaper"

i3 -C -c "$HOME/.config/i3/config"
if pgrep -x i3 >/dev/null; then i3-msg reload >/dev/null && echo "i3 recarregado."; fi
echo "Pronto! Coisas só desta máquina vão em ~/.config/i3/config.d/*.conf"
