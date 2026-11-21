#!/usr/bin/env bash
# Legenda/detalhes dos módulos da polybar: clique esquerdo -> notificação (dunst).
# Uso: info.sh cpu|temp|ram|gpu|disk|net|ping|weather|usd|updates|mouse|date
set -u
ID=7700   # mesma id = a notificação nova substitui a anterior
notify() { notify-send -a polybar -r "$ID" -t 12000 "$1" "$2"; }
mono() { sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' | sed 's/^/<tt>/; s/$/<\/tt>/'; }
cache="${XDG_CACHE_HOME:-$HOME/.cache}/polybar"

case "${1:-}" in
cpu)
  load=$(cut -d' ' -f1-3 /proc/loadavg)
  model=$(sed -n 's/^model name\s*: //p' /proc/cpuinfo | head -1)
  top=$(ps -eo pcpu,comm --sort=-pcpu --no-headers | head -6 | awk '{printf "%5.1f%%  %s\n",$1,$2}' | mono)
  notify "CPU — uso total" "$model ($(nproc) threads)
Load (1/5/15 min): $load

<b>Processos que mais usam CPU</b>
$top" ;;
temp)
  notify "Temperatura da CPU" "$(sensors 2>/dev/null | grep -E 'Tctl|Tccd|Package|Core 0' | mono)
Fica vermelho a partir de 80°C." ;;
ram)
  free=$(free -h --si | mono)
  top=$(ps -eo rss,comm --sort=-rss --no-headers | head -6 | awk '{printf "%6.1f GB  %s\n",$1/1048576,$2}' | mono)
  notify "RAM — memória livre" "\"livre\" = disponível para programas (inclui cache que pode ser liberado).
$free

<b>Processos que mais usam RAM</b>
$top" ;;
gpu)
  q=$(nvidia-smi --query-gpu=name,utilization.gpu,temperature.gpu,memory.used,memory.total,power.draw,fan.speed,clocks.gr --format=csv,noheader,nounits 2>/dev/null)
  IFS=', ' read -r -a _ <<<""
  name=$(cut -d, -f1 <<<"$q"); IFS=, read -r _ util temp used total pwr fan clk <<<"$q"
  procs=$(nvidia-smi --query-compute-apps=process_name,used_memory --format=csv,noheader 2>/dev/null | head -5 | mono)
  notify "GPU — $name" "Uso: ${util// /}%   Temp: ${temp// /}°C   Fan: ${fan// /}%
VRAM: ${used// /} / ${total// /} MiB   Consumo: ${pwr// /} W   Clock: ${clk// /} MHz
${procs:+
<b>Processos (CUDA)</b>
$procs}
Clique direito: btop" ;;
disk)
  notify "Disco — espaço livre" "$(df -h --output=target,size,used,avail,pcent / /home | mono)" ;;
net)
  dev=$(ip route show default | awk '{print $5; exit}')
  ip4=$(ip -4 -br addr show "$dev" | awk '{print $3}')
  gw=$(ip route show default | awk '{print $3; exit}')
  notify "Rede — download / upload" "Interface: $dev
IP local: $ip4   Gateway: $gw
Setas = velocidade atual de download (↓) e upload (↑)." ;;
ping)
  out=$(ping -n -c4 -i0.2 -W2 1.1.1.1 2>&1 | tail -2 | mono)
  pub=$(curl -s --max-time 4 https://api.ipify.org || echo "?")
  notify "Internet — está ok?" "Ping em 1.1.1.1 (Cloudflare) a cada 5 s.
<span color='#a6e3a1'>verde</span> &lt;80 ms · <span color='#f9e2af'>amarelo</span> &lt;200 ms · <span color='#fab387'>laranja</span> lento · <span color='#f38ba8'>vermelho</span> sem internet

$out
IP público: $pub" ;;
weather)
  LAT=-28.2994 LON=-54.2633
  j=$(curl -sf --max-time 8 "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current=temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,precipitation&hourly=temperature_2m,precipitation_probability&forecast_hours=12&daily=sunrise,sunset,uv_index_max&forecast_days=1&timezone=America%2FSao_Paulo") || { notify "Tempo" "Sem conexão com a Open-Meteo."; exit; }
  cur=$(jq -r '.current | "Agora: \(.temperature_2m)°C (sensação \(.apparent_temperature)°C)\nUmidade: \(.relative_humidity_2m)%   Vento: \(.wind_speed_10m) km/h   Chuva agora: \(.precipitation) mm"' <<<"$j")
  sun=$(jq -r '.daily | "Sol: \(.sunrise[0][11:16]) – \(.sunset[0][11:16])   UV máx: \(.uv_index_max[0])"' <<<"$j")
  hrs=$(jq -r '[.hourly.time, .hourly.temperature_2m, .hourly.precipitation_probability] | transpose | to_entries | map(select(.key % 2 == 0) | .value)[] | "\(.[0][11:16])  \(.[1]|round)°  chuva \(.[2])%"' <<<"$j" | mono)
  notify "Tempo — Santo Ângelo/RS" "$cur
$sun
Na barra: agora · mín/máx do dia · chance de chuva

<b>Próximas horas</b>
$hrs
Clique direito: previsão da semana" ;;
usd)
  j=$(cat "$cache/usd.json" 2>/dev/null)
  [ -z "$j" ] && { notify "Dólar" "Sem dados ainda."; exit; }
  notify "Dólar comercial (USD → BRL)" "$(jq -r '.USDBRL | "Compra: R$ \(.bid)   Venda: R$ \(.ask)\nMáx do dia: R$ \(.high)   Mín: R$ \(.low)\nVariação hoje: \(.pctChange)%\nAtualizado: \(.create_date)"' <<<"$j")
Variação positiva = dólar subindo (real perdendo valor).
Fonte: AwesomeAPI · clique direito: Google Finance" ;;
updates)
  list=$(cat "$cache/updates.txt" 2>/dev/null)
  n=$(grep -c . <<<"$list")
  notify "Atualizações pendentes: $n" "$(head -15 <<<"$list" | awk '{print $1, $4}' | mono)$( [ "$n" -gt 15 ] && printf '\n… e mais %d' $((n-15)))
Clique direito: rodar yay -Syu" ;;
mouse)
  p=$(ls -d /sys/class/power_supply/hidpp_battery_* 2>/dev/null | head -1)
  notify "Bateria do mouse" "$(cat "$p/model_name" 2>/dev/null)
Carga: $(cat "$p/capacity" 2>/dev/null)%   Estado: $(cat "$p/status" 2>/dev/null)
⚡ = carregando · fica vermelho com ≤20%" ;;
date)
  notify "Calendário" "$(cal | mono)" ;;
esac
