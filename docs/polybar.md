# Polybar (substitui i3bar + i3status)

Instalação: `bash ~/code/hyperspace/8_polybar.sh` (rode depois do `6_i3.sh`).
Configurado em 2026-11-20 no desktop `hyperspace` (i3/X11, NVIDIA RTX 3070, AMD/k10temp,
ultrawide DP-0 + Dell touch DP-2).

## Como funciona
- `dotfiles/i3/config` troca o bloco `bar { status_command i3status }` por
  `exec_always ~/.config/polybar/launch.sh`.
- `launch.sh` mata as polybars antigas, acha o sensor de temperatura da CPU (k10temp/coretemp,
  porque o `hwmonN` muda entre boots) e sobe uma barra por monitor: **main** no monitor mais largo
  (com tray e todos os módulos) e **side** nos outros (versão enxuta). Para forçar outro principal:
  `MAIN_MONITOR=DP-2`. Logs: `/tmp/polybar-$USER-<monitor>.log`.
- Visual: barra flutuante embaixo com cantos arredondados, paleta Catppuccin Mocha e fonte
  `AtkynsonMono Nerd Font Propo` (pacote `otf-atkinsonhyperlegiblemono-nerd`) para os ícones.
  Fallback: DejaVu Sans / Noto Color Emoji (glifos que a Nerd Font não tem, como ▲, ficam vazios sem isso).

## Módulos (iguais nas duas barras; só a principal tem o tray)
Sem rótulos fixos para a barra ficar limpa. **Clique esquerdo** em qualquer módulo abre uma
notificação (dunst, `scripts/info.sh <módulo>`) explicando o que é e com detalhes.
**Clique direito** faz a ação "pesada".

| Módulo | Fonte | Clique esquerdo (notificação) | Clique direito |
|---|---|---|---|
| workspaces do i3 (por monitor) | interno | troca de workspace | — |
| data/hora em PT-BR (`scripts/date.sh`; o sistema não tem locale pt_BR) | script | calendário do mês | alterna o formato longo |
| tempo em Santo Ângelo/RS: agora, mín/máx, chance de chuva | `scripts/weather.sh`, Open-Meteo (sem chave), a cada 15 min, com cache | sensação, umidade, vento, sol, UV, próximas horas | meteoblue |
| dólar USD→BRL (só o preço) | `scripts/usd.sh`, AwesomeAPI (sem chave), a cada 5 min, com cache (`*` = dado antigo) | compra/venda, máx/mín, variação do dia, horário | Google Finance |
| updates pendentes (pacman + AUR); some quando é 0 | `scripts/updates.sh` (`checkupdates` + `yay -Qua`, com cache e lock porque as duas barras chamam) | lista de pacotes | `yay -Syu` no ghostty |
| CPU % (vermelho ≥85%) | interno | modelo, load, top processos | btop |
| temperatura da CPU (vermelho ≥80°C) | interno (`CPU_TEMP_PATH` do launch.sh) | saída do `sensors` | — |
| RAM **livre** (vermelho com uso ≥90%) | interno | `free` + top processos | btop |
| GPU %, temperatura, VRAM | `scripts/gpu.sh` (`nvidia-smi`) | consumo, fan, clock, processos | btop |
| espaço livre em `/` e `/home` | `scripts/disk.sh` | `df` | — |
| download/upload do cabo | interno (`interface-type = wired`) | interface, IP, gateway | — |
| internet ok? ping 1.1.1.1/8.8.8.8 (verde <80ms, amarelo, laranja ≥200ms, vermelho = sem internet) | `scripts/netcheck.sh` | legenda das cores, 4 pings, IP público | — |
| tray (nm-applet etc.) | interno | — | — |

Os módulos `internal/*` não aceitam `click-left`; neles o clique é a tag `%{A1:cmd:}...%{A}` dentro do `format`.
Os módulos `pulseaudio` (volume) e `mouse` (bateria do G502) estão definidos no `config.ini`, mas
fora das barras: para usar, coloque-os em `modules-right`.
Tirei de propósito o título da janela (xwindow), porque não tinha utilidade.

## Notificações (dunst)
`dotfiles/dunst/dunstrc` → `~/.config/dunst/dunstrc`: Catppuccin, canto inferior direito do monitor
onde está o mouse, logo acima da barra. Clique esquerdo fecha, direito fecha todas.
O dunst sobe sozinho via D-Bus (não precisa de `exec` no i3).

## Ajustes comuns
- Outra cidade: troque `LAT`/`LON` em `scripts/weather.sh` (e o link `click-left` em `config.ini`).
- Barra no topo: `bottom = false` em `[bar/base]`.
- Largura fixa dos números (para a barra não "pular"): nos módulos internos com `%token:N%` (ex.: `%percentage:3%`), nos scripts com `printf "%3s"`. A fonte é mono, então N caracteres sempre ocupam o mesmo espaço.
- Nos scripts, cuidado com `%` literal colado em `%{...}`: `%%{` é o escape da polybar.
- Testar um script: `~/.config/polybar/scripts/usd.sh` (a saída tem as tags `%{F#..}` da polybar).
- Recarregar: `~/.config/polybar/launch.sh` ou reload do i3.
