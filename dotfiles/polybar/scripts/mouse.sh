#!/usr/bin/env bash
# Bateria do mouse sem fio (Logitech via hidpp). Some se não houver.
for p in /sys/class/power_supply/hidpp_battery_*; do
  [ -r "$p/capacity" ] || continue
  cap=$(cat "$p/capacity"); st=$(cat "$p/status")
  c="#a6adc8"; [ "$cap" -le 20 ] && c="#f38ba8"
  bolt=""; [ "$st" = Charging ] && bolt="%{F#f9e2af}"$'\U000F140B'"%{F-}"
  echo "%{F$c}%{T2}"$'\U000F037D'"%{T-}%{F-}$bolt $cap%"; exit
done
echo ""
