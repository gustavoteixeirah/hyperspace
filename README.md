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


