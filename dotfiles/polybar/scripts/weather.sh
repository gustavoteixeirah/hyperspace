#!/usr/bin/env bash
# Tempo agora em Santo Ângelo/RS (Open-Meteo, sem chave): ícone, temperatura,
# mín/máx do dia e chance de chuva. Troque LAT/LON para outra cidade.
LAT=-28.2994 LON=-54.2633
cache="${XDG_CACHE_HOME:-$HOME/.cache}/polybar/weather.json"; mkdir -p "${cache%/*}"
url="https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current=temperature_2m,weather_code,is_day&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max&forecast_days=1&timezone=America%2FSao_Paulo"
if json=$(curl -sf --max-time 8 "$url") && jq -e .current >/dev/null <<<"$json"; then
  echo "$json" >"$cache"
else
  json=$(cat "$cache" 2>/dev/null) || { echo "%{F#6c7086}"$'\U000F0590'" --%{F-}"; exit; }
fi
read -r t code day tmin tmax rain < <(jq -r '[.current.temperature_2m, .current.weather_code, .current.is_day, .daily.temperature_2m_min[0], .daily.temperature_2m_max[0], .daily.precipitation_probability_max[0]] | map(tostring) | join(" ")' <<<"$json")
# códigos WMO -> ícone (Nerd Font md-weather_*)
case "$code" in
  0)  [ "$day" = 1 ] && i=$'\U000F0599' || i=$'\U000F0594' ;;              # céu limpo
  1|2) [ "$day" = 1 ] && i=$'\U000F0595' || i=$'\U000F0F31' ;;             # parcialmente nublado
  3)  i=$'\U000F0590' ;;                                                   # nublado
  45|48) i=$'\U000F0591' ;;                                                # neblina
  51|53|55|56|57|61|63|80|81) i=$'\U000F0597' ;;                           # chuva
  65|66|67|82) i=$'\U000F0596' ;;                                          # chuva forte
  71|73|75|77|85|86) i=$'\U000F0598' ;;                                    # neve
  95|96|99) i=$'\U000F0593' ;;                                             # tempestade
  *)  i=$'\U000F0590' ;;
esac
r(){ LC_ALL=C printf '%.0f' "$1"; }
drop=$'\U000F058C'
printf '%%{F#f9e2af}%%{T2}%s%%{T-}%%{F-} %2s° %%{F#a6adc8}%2s°/%s°%%{F-} %%{F#89b4fa}%s%%{F-}%3s%%\n' "$i" "$(r "$t")" "$(r "$tmin")" "$(r "$tmax")" "$drop" "$rain"
