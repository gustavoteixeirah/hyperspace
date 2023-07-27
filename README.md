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
```
sudo pacman -Syy && sudo pacman -Syu
```
