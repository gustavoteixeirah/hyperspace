#!/usr/bin/env bash
# Touchscreen do monitor Dell P2424HT no Arch + i3 (X11)
# Uso: bash ~/code/hyperspace/7_dell_touch.sh [SAIDA]   (padrão: DP-2; pode rodar de novo)
# Detalhes e troubleshooting: docs/dell-p2424ht-touch.md
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT="${1:-DP-2}"

sudo pacman -S --needed --noconfirm xorg-xinput

mkdir -p "$HOME/.local/bin" "$HOME/.config/i3/config.d"
install -v -m 755 "$REPO/dotfiles/bin/dell-touch-map" "$HOME/.local/bin/dell-touch-map"
sed "s|dell-touch-map\$|dell-touch-map $OUTPUT|" "$REPO/dotfiles/i3/config.d/dell-touch.conf" \
  > "$HOME/.config/i3/config.d/dell-touch.conf"

# layout dos monitores (ultrawide em cima, Dell embaixo), salvo pelo arandr; o i3 aplica no login
mkdir -p "$HOME/.screenlayout"
install -v -m 755 "$REPO/dotfiles/screenlayout/hyperspace.sh" "$HOME/.screenlayout/hyperspace.sh"
cp -v "$REPO/dotfiles/i3/config.d/monitors.conf" "$HOME/.config/i3/config.d/monitors.conf"

if ! grep -qi 'SiW HID Touch' /proc/bus/input/devices; then
  echo "AVISO: touch não detectado. Ligue o cabo USB (USB-A -> USB-C upstream) do monitor ao PC."
fi

if pgrep -x i3 >/dev/null; then i3-msg reload >/dev/null || true; fi
"$HOME/.local/bin/dell-touch-map" "$OUTPUT" || true
echo "Pronto! Touch mapeado para $OUTPUT."
