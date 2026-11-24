#!/bin/sh
# Layout dos monitores do hyperspace (gerado a partir do arandr e rodado pelo i3 no login).
#   DP-0  ultrawide 3440x1440 @ 99.98  -> em cima, à esquerda (primário)
#   DP-4  1920x1080 @ 119.98            -> à direita do ultrawide
#   DP-2  Dell P2424HT touch 1920x1080   -> embaixo do ultrawide
# Só configura as saídas conectadas: se um monitor estiver desligado, o resto sobe igual
# (um xrandr com saída desconectada falharia inteiro).
connected() { xrandr --query | grep -q "^$1 connected"; }

set -- --output DP-0 --primary --mode 3440x1440 --rate 99.98 --pos 0x0 --rotate normal
connected DP-4 && set -- "$@" --output DP-4 --mode 1920x1080 --rate 119.98 --pos 3440x239 --rotate normal
connected DP-2 && set -- "$@" --output DP-2 --mode 1920x1080 --rate 60 --pos 825x1440 --rotate normal

xrandr "$@"
