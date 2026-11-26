#!/bin/sh
# Layout dos monitores do hyperspace (ajustado no arandr e rodado pelo i3 no login).
#   DP-0  ultrawide 3440x1440 @ 99.98  -> à esquerda (primário)
#   DP-2  Dell P2424HT touch 1920x1080  -> à direita do ultrawide
# Só configura as saídas conectadas: se um monitor estiver desligado, o resto sobe igual
# (um xrandr com saída desconectada falharia inteiro).
connected() { xrandr --query | grep -q "^$1 connected"; }

set -- --output DP-0 --primary --mode 3440x1440 --rate 99.98 --pos 0x0 --rotate normal
connected DP-2 && set -- "$@" --output DP-2 --mode 1920x1080 --rate 60 --pos 3440x243 --rotate normal

xrandr "$@"
