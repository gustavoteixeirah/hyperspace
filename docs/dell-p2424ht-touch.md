# Touchscreen Dell P2424HT no Arch Linux (i3 / X11)

Monitor: **Dell P2424HT** (23.8", 1920x1080, touch, hub USB-C). Configurado em 2026-11-20
no desktop `hyperspace` (Arch, kernel 7.2, NVIDIA, Xorg + i3, dois monitores).

## TL;DR (depois de formatar)

1. Ligue o **cabo USB** do monitor ao PC (ver "Hardware" abaixo). Só o DP/HDMI **não** basta.
2. Rode:
   ```bash
   bash ~/code/hyperspace/7_dell_touch.sh        # saída padrão DP-2
   bash ~/code/hyperspace/7_dell_touch.sh HDMI-0 # se o Dell estiver em outra saída (ver xrandr)
   ```
3. Toque na tela do Dell e confira se o cursor vai para o ponto tocado.

## Hardware: o que é necessário

- O vídeo vai pelo **DisplayPort** (placa NVIDIA, cabo DP→DP da caixa).
- O touch vai **por USB**: usar o cabo **USB-A → USB-C** da caixa, com o lado C na porta
  **USB-C upstream** do monitor (a nº 6 nas especificações) e o lado A em qualquer USB do PC.
  (Com um cabo USB-C→USB-C a partir de uma porta com DP Alt Mode, um cabo só leva vídeo + touch.)
- Sem o cabo USB, nada do monitor aparece no `/sys/bus/usb/devices` e o touch não existe para o SO.
- Bônus do cabo USB: o hub do monitor (portas USB e Ethernet RJ45 Realtek r8152) também passa a funcionar.

## Driver

**Não precisa de driver.** O touch é um HID multitouch padrão e o kernel usa `hid-multitouch`.
O manual da Dell diz que no Linux é **3 pontos de toque** (10 no Windows/macOS).

Dispositivos USB que aparecem com o cabo ligado:

| ID | Dispositivo |
|----|-------------|
| `1fd2:b101` | **Siliconworks SiW HID Touch Controller** ← o touch |
| `0bda:5409` / `0bda:0409` | Hubs Realtek USB2/USB3 do monitor |
| `0bda:8153` | Ethernet Realtek r8152 |
| `0bda:54bb` / `0bda:1100` | Billboard / HID Realtek (controle do monitor) |

Dispositivos xinput: `Siliconworks SiW HID Touch Controller` e `Siliconworks SiW HID Touch Controller Mouse`.

## O problema com dois monitores e a solução

No X11, um touchscreen é mapeado para o **framebuffer inteiro** por padrão (aqui: ultrawide
DP-0 3440x1440 em +0+0, DP-4 1920x1080 à direita e Dell DP-2 1920x1080 embaixo). Por isso o toque cai na posição
errada. A solução é prender o touch à saída do Dell com `xinput map-to-output`, que calcula a
`Coordinate Transformation Matrix`.

Arquivos (no repo → instalados em):

- `dotfiles/bin/dell-touch-map` → `~/.local/bin/dell-touch-map`
  roda `xinput map-to-output "pointer:<nome>" DP-2` para os dois dispositivos SiW.
- `dotfiles/i3/config.d/dell-touch.conf` → `~/.config/i3/config.d/dell-touch.conf`
  `exec_always` que chama o script a cada start/reload do i3. A config principal do i3
  já tem `include ~/.config/i3/config.d/*.conf`, e o `6_i3.sh` não mexe no `config.d`.
- Pacote necessário: `xorg-xinput` (o `libinput` e o `xf86-input-libinput` já vêm com o Xorg).

## Verificação / troubleshooting

```bash
# o touch foi detectado?
grep -i siw /proc/bus/input/devices
journalctl -k -b | grep -iE 'siw|hid-multitouch'
# qual saída é o Dell? (o de 1920x1080, 527mm x 296mm)
xrandr | grep ' connected'
# mapeamento aplicado?
xinput list | grep -i siw
xinput list-props "pointer:Siliconworks SiW HID Touch Controller" | grep 'Coordinate Transformation'
# com o layout atual (3 monitores, framebuffer 5360x2520), o esperado é ~ 0.358 0 0.154 / 0 0.429 0.571 / 0 0 1
```

- **O toque parou de cair no lugar** (depois de reconectar o USB, religar o monitor ou de um
  `yay -Syu`): o X zerou a `Coordinate Transformation Matrix` (volta à identidade). O
  `dotfiles/bin/input-watch` (iniciado pelo i3) confere a cada 3s e reaplica o `dell-touch-map`
  sozinho. Se o vigia não estiver rodando (`pgrep -f input-watch`), rode `dell-touch-map` na mão ou
  `i3-msg restart` (o `reload` não roda os `exec_always`).
- **Mexeu no layout (arandr):** o `input-watch` percebe a mudança (`xrandr --listactivemonitors`) e
  remapeia o touch + reinicia a polybar sozinho. Para o layout sobreviver ao reboot, salve no arandr
  em `~/.screenlayout/hyperspace.sh`; o i3 roda esse script no login via
  `~/.config/i3/config.d/monitors.conf`. Os dois estão no repo (`dotfiles/screenlayout/hyperspace.sh`,
  `dotfiles/i3/config.d/monitors.conf`) e são instalados pelo `7_dell_touch.sh`. O script é uma versão
  editada do que o arandr salva: marca o DP-0 como primário e só configura as saídas conectadas
  (um `xrandr` com um monitor desligado falharia inteiro). Ao mudar o layout no arandr, copie as
  posições (`--pos`) para ele em vez de sobrescrevê-lo. Layout atual (2026-11-24, três monitores):

  | Saída | Monitor | Modo | Posição |
  |---|---|---|---|
  | DP-0 | ultrawide (primário, polybar com tray) | 3440x1440 @ 99.98 | `0x0` |
  | DP-4 | 1920x1080 (531mm x 299mm) | 1920x1080 @ 119.98 | `3440x239` (à direita do ultrawide) |
  | DP-2 | Dell P2424HT touch | 1920x1080 @ 60 | `825x1440` (embaixo do ultrawide) |
- **Mudou a saída do Dell (ex.: HDMI):** rode `dell-touch-map <saída>` e atualize a
  saída em `~/.config/i3/config.d/dell-touch.conf` (ou rode `7_dell_touch.sh <saída>` de novo).
- **Monitor girado (pivot):** primeiro gire com `xrandr --output DP-2 --rotate left`, depois rode
  `dell-touch-map`. O map-to-output já leva a rotação em conta.
- **Wayland (se migrar para sway/Hyprland):** o xinput não serve. No sway use
  `input "8146:45313:Siliconworks_SiW_HID_Touch_Controller" map_to_output DP-2`
  (confira o identificador com `swaymsg -t get_inputs`); no Hyprland use `input:touchdevice:output`.

## Referências

- Dell, problema de touch no P2424HT (precisa do cabo USB upstream): https://www.dell.com/support/kbdoc/en-ie/000225948/touch-function-does-not-work-on-dell-p2424ht?lang=en
- Manual do P2424HT (3 pontos de toque no Linux): https://manuals.online/dell/monitor/p2424ht/user-manual/wsjm
