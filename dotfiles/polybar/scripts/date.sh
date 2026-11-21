#!/usr/bin/env bash
# Data/hora em português (o sistema não tem locale pt_BR). Clique alterna o formato longo.
state="${XDG_RUNTIME_DIR:-/tmp}/polybar-date-long"
if [ "$1" = "--toggle" ]; then [ -e "$state" ] && rm "$state" || touch "$state"; exit; fi
dias=(dom seg ter qua qui sex sáb); meses=(jan fev mar abr mai jun jul ago set out nov dez)
read -r u d m y hm <<<"$(date '+%w %-d %-m %Y %H:%M')"
cal=$'\U000F00ED'; clk=$'\U000F0150'
if [ -e "$state" ]; then
  printf '%%{F#cba6f7}%s%%{F-} %s, %s de %s de %s  %%{F#cba6f7}%s%%{F-} %%{T3}%s%%{T-}\n' "$cal" "${dias[$u]}" "$d" "${meses[$((m-1))]}" "$y" "$clk" "$hm"
else
  printf '%%{F#cba6f7}%s%%{F-} %s %02d/%02d  %%{T3}%s%%{T-}\n' "$cal" "${dias[$u]}" "$d" "$m" "$hm"
fi
