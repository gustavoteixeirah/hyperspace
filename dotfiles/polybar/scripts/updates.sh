#!/usr/bin/env bash
# Atualizações pendentes (repos oficiais + AUR). Some quando está tudo em dia.
# As duas barras chamam isto: um lock + cache de 25 min evita rodar checkupdates em paralelo.
cache="${XDG_CACHE_HOME:-$HOME/.cache}/polybar/updates.txt"; mkdir -p "${cache%/*}"
exec 9>"$cache.lock"; flock 9
if [ ! -s "$cache" ] || [ -n "$(find "$cache" -mmin +25)" ]; then
  { checkupdates 2>/dev/null; command -v yay >/dev/null && yay -Qua 2>/dev/null; } >"$cache.tmp"
  mv "$cache.tmp" "$cache"
fi
n=$(grep -c . "$cache")
[ "$n" -eq 0 ] && { echo ""; exit; }
printf "%%{F#89b4fa}%%{T2}%s%%{T-}%%{F-} %3s\n" $'\U000F08C7' "$n"
