#!/usr/bin/env bash
# Sobe uma polybar por monitor: "main" (com tray) no maior, "side" nos outros.
# Chamado pelo i3 (exec_always), então roda de novo a cada reload.
pkill -x polybar
while pgrep -x polybar >/dev/null; do sleep 0.1; done

# sensor de temperatura da CPU (k10temp = AMD, coretemp = Intel); hwmonN muda entre boots
for h in /sys/class/hwmon/hwmon*; do
  case "$(cat "$h/name")" in k10temp|coretemp|zenpower) export CPU_TEMP_PATH="$h/temp1_input"; break;; esac
done

# monitor principal = o de maior largura (ou MAIN_MONITOR=DP-0 no ambiente)
main="${MAIN_MONITOR:-$(xrandr --listactivemonitors | awk 'NR>1{split($3,a,"/"); print a[1], $4}' | sort -rn | head -1 | cut -d' ' -f2)}"

for m in $(polybar --list-monitors | cut -d: -f1); do
  bar=side; [ "$m" = "$main" ] && bar=main
  MONITOR=$m polybar --reload "$bar" >>"/tmp/polybar-$USER-$m.log" 2>&1 & disown
done
