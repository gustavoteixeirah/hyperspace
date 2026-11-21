#!/usr/bin/env bash
# Internet OK? Faz ping em 1.1.1.1 / 8.8.8.8 e mostra a latência
ok=$'\U000F059F'; off=$'\U000F0A8E'
for host in 1.1.1.1 8.8.8.8; do
  ms=$(ping -n -c1 -W2 "$host" 2>/dev/null | sed -n 's/.*time=\([0-9.]*\).*/\1/p')
  [ -n "$ms" ] && break
done
if [ -z "$ms" ]; then
  echo "%{F#f38ba8}%{T2}$off%{T-} sem internet%{F-}"; exit
fi
ms=${ms%.*}
c="#a6e3a1"; [ "$ms" -ge 80 ] && c="#f9e2af"; [ "$ms" -ge 200 ] && c="#fab387"
printf "%%{F%s}%%{T2}%s%%{T-}%%{F-} %3s ms\n" "$c" "$ok" "$ms"
