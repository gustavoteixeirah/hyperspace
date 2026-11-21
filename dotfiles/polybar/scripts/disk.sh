#!/usr/bin/env bash
# Espaço livre em / e /home, compacto
df -h --output=target,avail / /home 2>/dev/null | awk 'NR>1{printf "%s%s %5s", (NR>2?"  ":""), $1, $2} END{print ""}' | sed 's/^/%{F#b4befe}%{T2}\xf3\xb0\x8b\x8a%{T-}%{F-} /'
