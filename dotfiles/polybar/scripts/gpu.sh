#!/usr/bin/env bash
# NVIDIA: uso %, temperatura e VRAM usada
read -r util temp used total < <(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null | tr -d ',')
icon=$'\U000F08AE'
[ -z "$util" ] && { echo "%{F#6c7086}$icon n/d%{F-}"; exit; }
c="#cba6f7"; [ "$util" -ge 90 ] && c="#f38ba8"
vram=$(awk -v u="$used" 'BEGIN{printf "%.1fG", u/1024}')
printf '%%{F%s}%%{T2}%s%%{T-}%%{F-} %3s%%  %%{F#a6adc8}%2s° %4s%%{F-}\n' "$c" "$icon" "$util" "$temp" "$vram"
