#!/usr/bin/env bash
# Polybar no lugar do i3bar/i3status: CPU, temp, RAM livre, GPU NVIDIA, disco, rede + ping,
# dólar (USD->BRL), tempo em Santo Ângelo/RS, updates do pacman/AUR. Clique = notificação (dunst) com detalhes.
# Uso: bash ~/code/hyperspace/8_polybar.sh   (pode rodar de novo; rode depois do 6_i3.sh)
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ts="$(date +%Y%m%d%H%M%S)"

# fonte com ícones (Nerd Font) usada na barra
sudo pacman -S --needed --noconfirm polybar pacman-contrib jq curl lm_sensors pavucontrol btop dunst libnotify otf-atkinsonhyperlegiblemono-nerd

[[ -d "$HOME/.config/polybar" ]] && cp -r "$HOME/.config/polybar" "$HOME/.config/polybar.bak-$ts"
mkdir -p "$HOME/.config/polybar"
cp -rv "$REPO/dotfiles/polybar/." "$HOME/.config/polybar/"
chmod +x "$HOME/.config/polybar/launch.sh" "$HOME/.config/polybar/scripts/"*.sh

# dunst: mostra a legenda/detalhes quando clica num módulo
mkdir -p "$HOME/.config/dunst"
[[ -f "$HOME/.config/dunst/dunstrc" ]] && cp "$HOME/.config/dunst/dunstrc" "$HOME/.config/dunst/dunstrc.bak-$ts"
cp -v "$REPO/dotfiles/dunst/dunstrc" "$HOME/.config/dunst/dunstrc"
pkill -x dunst || true   # sobe sozinho via D-Bus na próxima notificação

if pgrep -x i3 >/dev/null; then i3-msg restart >/dev/null || true; echo "i3 reiniciado."; fi
echo "Pronto! Config em ~/.config/polybar (veja docs/polybar.md)."
