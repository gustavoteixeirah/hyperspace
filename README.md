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
