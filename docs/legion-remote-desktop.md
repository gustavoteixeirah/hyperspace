# Legion na tela do hyperspace (Sunshine + Moonlight)

Configurado em 2026-11-25. Objetivo: usar o **Legion** (notebook Arch na rede local) como se fosse
mais um monitor do **hyperspace**: a tela do Legion aparece numa janela/tela cheia num monitor daqui,
em **3440x1440 sem faixas pretas**, com o teclado e o mouse do hyperspace, e dá para ir e voltar
entre o Legion e os outros monitores sem travar.

## As máquinas

| | hyperspace (desktop) | legion (notebook) |
|---|---|---|
| IP na LAN | <ip-da-lan> | <ip-da-lan> (`ssh legion`) |
| GPU | RTX 3070 | RTX 3060 Mobile, só a NVIDIA (sem iGPU no X), driver `nvidia-open` |
| Sessão | i3 / X11 | i3 / X11, iniciado por `startx` a partir do `cosmic-greeter` (greetd) |
| $mod do i3 | Caps Lock (Hyper, Mod3) | **Alt (Mod1)**, ver "Teclado" |
| Teclado | US | físico ABNT2; o que chega pelo Moonlight usa US |
| Papel | cliente **Moonlight** | servidor **Sunshine** |

## TL;DR (refazer do zero)

```bash
bash ~/code/hyperspace/9_legion_remote.sh   # roda no hyperspace; pede sudo daqui e do Legion
```
Depois: reiniciar o Legion → abrir o Moonlight → adicionar o host `<ip-da-lan>` (a busca automática
não acha, falta avahi no Legion) → parear (ver "Pareamento") → abrir **Desktop**.

Arquivos no repo (`dotfiles/legion/`) → onde ficam:

| Repo | Destino | O que faz |
|---|---|---|
| `xorg/20-nvidia-virtual-ultrawide.conf` | Legion `/etc/X11/xorg.conf.d/` | finge um monitor ultrawide ligado no DP-0 |
| `edid/asus-xg35v.edid` | Legion `/etc/X11/edid/` | EDID do ultrawide real do hyperspace |
| `xorg/30-sunshine-keyboard-us.conf` | Legion `/etc/X11/xorg.conf.d/` | layout US no teclado virtual do Sunshine |
| `bin/legion-display` | Legion `~/.local/bin/` | alterna ultrawide virtual ↔ tela do notebook |
| `i3/remote.conf` | Legion `~/.config/i3/config.d/` | i3 liga o ultrawide virtual ao iniciar |
| `sunshine/sunshine.conf` | Legion `~/.config/sunshine/` | captura X11, NVENC, monitor 0 |
| `greetd/initial_session.toml` | anexado a `/etc/greetd/cosmic-greeter.toml` | login automático no i3 |
| `moonlight.conf` | hyperspace `~/.config/Moonlight Game Streaming Project/Moonlight.conf` | resolução, mouse livre, sem captura de teclado |

## Uso no dia a dia

- Moonlight → `legion` → **Desktop**. Abre em tela cheia no monitor onde a janela estiver; para
  nitidez total, deixe-o numa área de trabalho do ultrawide (num monitor 1920x1080 fica reduzido).
- O mouse passa livre entre o Legion e os outros monitores; o foco segue o mouse (i3).
- **Caps + tecla** → sempre o i3 do hyperspace (trocar área de trabalho, sair do Legion etc.).
- **Alt + tecla** (com o mouse sobre o Legion) → i3 do Legion: Alt+Enter terminal, Alt+D rofi,
  Alt+1..9 áreas de trabalho, Alt+Shift+Q fecha janela.
- **Ctrl+Alt+Shift+Q** encerra a sessão do Moonlight (o desktop do Legion continua rodando).
- O áudio do Legion toca no hyperspace durante a sessão.
- Usar o notebook na mão: no Legion, `legion-display notebook`; voltar: `legion-display ultrawide`.
- Fechar o Moonlight daqui se travar: `pkill moonlight`. Encerrar a transmissão pelo Legion:
  `ssh legion 'curl -sk -u USER:SENHA -X POST https://localhost:47990/api/apps/close'`.

## Como funciona (e o que foi descoberto)

### 1. Ultrawide virtual sem cabo

- Ligar um HDMI do Legion no ultrawide geraria a resolução, mas o monitor só mostra uma entrada por
  vez e muitos "desligam" a entrada inativa → o Legion veria o monitor sumir. Descartado.
- O driver NVIDIA (X11) aceita fingir um monitor: `ConnectedMonitor` + `CustomEDID`. O EDID foi
  copiado do ultrawide real do hyperspace (ASUS XG35V, 3440x1440 @ 99.98):
  ```bash
  # no hyperspace (sem xxd instalado, por isso python)
  xrandr --verbose | awk '/^DP-0 /{f=1} f&&/EDID:/{e=1;next} e&&/^[ \t]+[0-9a-f]+$/{gsub(/[ \t]/,"");printf "%s",$0;next} e{exit}' \
    | python3 -c 'import sys;open("ultrawide.edid","wb").write(bytes.fromhex(sys.stdin.read().strip()))'
  ```
- Saídas do Legion (log `~/.local/share/xorg/Xorg.0.log`): `DFP-5` = tela do notebook (`DP-4` no
  xrandr); `DFP-0`/`DFP-2` = DisplayPort livres (2670 MHz); `DFP-1/3/4` = TMDS/HDMI, só **165 MHz**
  quando desconectado, pouco para 3440x1440@100. Por isso o monitor falso fica no **DFP-0 (= DP-0)**.
- `DFP-5` continua em `ConnectedMonitor` para a tela do notebook poder voltar; quem a desliga é o
  `legion-display ultrawide` (`xrandr --output DP-4 --off`), rodado pelo i3 ao iniciar.
- Para desfazer: apagar `20-nvidia-virtual-ultrawide.conf` e reiniciar o X.

### 2. Sunshine (Legion)

- Pacote AUR `sunshine-bin`. Serviço de usuário `app-dev.lizardbyte.app.Sunshine.service` (o alias
  `sunshine.service` só existe se habilitado). O i3 do Legion não ativa o `graphical-session.target`,
  então quem (re)inicia o serviço é o `legion-display`.
- Config: `capture = x11`, `encoder = nvenc`, `output_name = 0` (só o DP-0 fica ativo). No log:
  `Streaming display: DP-0 with res 3440x1440` e `Found HEVC encoder: hevc_nvenc`.
- Erros que podem ser ignorados: `Failed to gain CAP_SYS_ADMIN` (é da captura KMS, não usada) e
  `Failed to create client: Daemon not running` (avahi; só afeta a descoberta automática).
- Painel web: `https://<ip-da-lan>:47990`. Credenciais definidas com `sunshine --creds USER SENHA`.
- Firewall (ufw) do Legion já libera tudo vindo de `<ip-da-lan>`.
- Entrada: o pacote instala a regra udev de `/dev/uinput`; `uinput` carregado no boot via
  `/etc/modules-load.d/uinput.conf`.

### 3. Login automático (Legion)

- O display manager é o **`cosmic-greeter.service`** (greetd com `/etc/greetd/cosmic-greeter.toml`).
  Existe também um `greetd.service` **desabilitado**; não reinicie esse (ele sobe um segundo greeter
  no tty1). Aconteceu na instalação.
- `[initial_session]` faz o login automático no i3 (o mesmo comando `startx` que o greeter usa). O
  greetd só roda o initial_session uma vez por boot (marca em `/run/greetd.run`).
- Reiniciar a sessão gráfica remotamente: `sudo loginctl terminate-session <id>` e depois
  `sudo rm -f /run/greetd.run; sudo systemctl restart cosmic-greeter.service` (fecha tudo que estava aberto).
- Tampa fechada não suspende (`HandleLidSwitch*=ignore` em `/etc/systemd/logind.conf`, já estava).

### 4. Moonlight (hyperspace) e o pareamento

- `sudo pacman -S moonlight-qt` (repositório extra).
- Adicionar o host pelo IP. O Moonlight mostra um PIN; essa versão do Sunshine exige também o
  `pairing_id` da solicitação pendente:
  ```bash
  ssh legion 'curl -sk -u USER:SENHA https://localhost:47990/api/pin'   # lista {address,id,name}
  ssh legion 'curl -sk -u USER:SENHA -X POST https://localhost:47990/api/pin -H "Content-Type: application/json" \
    -d "{\"pairing_id\":\"<id>\",\"pin\":\"<PIN>\",\"name\":\"hyperspace\"}"'
  ```
  Confira se o `address` da solicitação é o IP do hyperspace antes de aprovar.
- **Configure antes de abrir o Desktop** (o padrão é 1280x720). As chaves ficam em
  `dotfiles/legion/moonlight.conf`; edite o `Moonlight.conf` só com o Moonlight fechado.

### 5. Teclado e mouse: usar os dois PCs ao mesmo tempo

- Com captura de teclado, o Moonlight engole o Caps do hyperspace; sem captura, os dois i3 usavam o
  Caps (Mod3) e o i3 do **hyperspace** pegava os atalhos antes do Moonlight: comandos rodavam no
  hyperspace e o foco pulava para lá.
- Solução: `capturesyskeys=0` (nunca captura) + `mouseacceleration=true` ("mouse para área de
  trabalho remota": o ponteiro não fica preso).
- **Sem captura o Moonlight não repassa a tecla Windows.** Win+tecla não chega ao Legion, por isso o
  `$mod` do Legion virou **Alt** (`set $mod Mod1`). O Legion tinha um quickterm em `Mod4+Return` que
  conflitava quando o $mod foi Mod4; ficou comentado. Backup: `~/.config/i3/config.bak-claude-mod4`.
- Layout: o Sunshine cria o teclado virtual `libvirtualhid Keyboard`, que pegava o ABNT2 do
  `00-keyboard.conf` (a barra virava ponto e vírgula). O `30-sunshine-keyboard-us.conf` dá US só a ele.
  Esse arquivo só é lido quando o X inicia; se o Sunshine recriar o dispositivo antes disso, aplique na mão:
  ```bash
  ssh legion 'export DISPLAY=:0; id=$(xinput list | grep "libvirtualhid Keyboard.*slave  keyboard" | grep -o "id=[0-9]*" | cut -d= -f2); setxkbmap -device $id -model pc105 -layout us -option terminate:ctrl_alt_bksp'
  ```

## Troubleshooting

- **Sem imagem / Moonlight não conecta:** `ssh legion 'systemctl --user status app-dev.lizardbyte.app.Sunshine.service; tail ~/.config/sunshine/sunshine.log'`.
- **Ultrawide virtual não aparece** (`xrandr` do Legion sem DP-0): `grep DFP-0 ~/.local/share/xorg/Xorg.0.log` deve mostrar `ASUS XG35V (DFP-0): connected`.
- **Legion subiu no greeter em vez do i3:** o initial_session já rodou neste boot; ver seção 3.
- **i3 do Legion acusa erro de config:** `ssh legion 'DISPLAY=:0 i3 -C -c ~/.config/i3/config'` (costuma ser atalho duplicado depois de mudar o $mod).
