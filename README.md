# Hyperspace GT's setup files

Arch installation
```bash
pacman-key --init
pacman-key --populate archlinux
archinstall
```
After installing stuff, hit `no` when asked to chroot, then `reboot`. Remove USB.

Now, do your post installation steps.



### Maintenance
Equivalent of `apt-get update && apt-get upgrade` in Arch:
```bash
sudo pacman -Syy && sudo pacman -Syu
```

Keyboard layout for legion:
```bash
setxkbmap -model abnt2 -layout br -variant abnt2
```

Connect to WiFi: open terminal an enter:
```bash
nmtui
```

Having internet problems? Try:
```
nmcli n off; nmcli n on
```

### Installing pkg.tar.zst
```bash
sudo pacman -U --noconfirm your-package.pkg.tar.zst
```


### Kill stuff
check processes running on port x:
```bash
sudo ss -tuln | grep :3000
```

kill
```bash
kill $(lsof -t -i:3000)
```


Wifi problems? Try:
```bash
rfkill unblock all
```

### Connect WiFi with `iwctl`

check connectivity
```bash
iwctl device list
```

connect to SSID
```bash
iwctl station  wlan0  connect TP-Link_0AF4
 ````


check devices connected in my network
```bash
nmap -sP -n 192.168.100.0/24
```


Disable screen saver:
```bash
xset s off
```
https://gist.github.com/gustavoteixeirah/688462ad6d43d5d2838edccb3fc11350

https://gist.githubusercontent.com/gustavoteixeirah/688462ad6d43d5d2838edccb3fc11350/raw/f4ca10bf6716beb2423f5fb1323e3604fdb30bfc/gistfile1.txt

### Terminal (zsh + oh-my-zsh + Powerlevel10k)
```bash
bash ~/code/hyperspace/5_terminal.sh
```
Instala zsh, fzf, ghostty, oh-my-zsh, os plugins (autosuggestions, syntax-highlighting, history-substring-search) e o Powerlevel10k, e copia `dotfiles/zsh/.zshrc` e `.p10k.zsh` para a home (com backup).
Segredos e variáveis específicas da máquina vão em `~/.zshrc.local` (não versionado).

### i3 (Caps Lock = mod, terminal rápido, gaps)
```bash
bash ~/code/hyperspace/6_i3.sh
```
Copia `dotfiles/i3/config` para `~/.config/i3/config` (com backup) e o script `wallpaper` para `~/.local/bin`.
- **Caps Lock** é o `$mod` (sozinho, no Mod3); a tecla **Windows** fica livre.
- **Win+Enter** abre um terminal flutuante no centro, por cima de tudo; **Esc** fecha.
- Gaps, sem bordas, `$mod+Shift+g` ajusta gaps, `$mod+Shift+w` troca o wallpaper.
- Funciona em teclado US e ABNT2 (a tecla `;`/`ç` é usada via keycode).
- Coisas específicas da máquina (ex.: lock de tela no notebook) vão em `~/.config/i3/config.d/*.conf` (não versionado).
