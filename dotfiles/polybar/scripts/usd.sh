#!/usr/bin/env bash
# Cotação USD -> BRL (AwesomeAPI, sem chave), só o preço; detalhes no clique (info.sh usd). Usa cache se a API falhar.
cache="${XDG_CACHE_HOME:-$HOME/.cache}/polybar/usd.json"; mkdir -p "${cache%/*}"
icon=$'\U000F01C1'
if json=$(curl -sf --max-time 8 https://economia.awesomeapi.com.br/json/last/USD-BRL) && jq -e .USDBRL.bid >/dev/null <<<"$json"; then
  echo "$json" >"$cache"; stale=""
else
  json=$(cat "$cache" 2>/dev/null) || { echo "%{F#6c7086}$icon --%{F-}"; exit; }
  stale="%{F#6c7086}*%{F-}"
fi
bid=$(jq -r .USDBRL.bid <<<"$json")
price=$(LC_ALL=C printf '%.2f' "$bid" | tr . ,)
printf '%%{F#a6e3a1}%%{T2}%s%%{T-}%%{F-} R$ %s%s\n' "$icon" "$price" "$stale"
