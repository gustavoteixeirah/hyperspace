# Arch Installation & Scripts


Carrega keymaps 
```
loadkeys br-abnt2
```
Ajusta fuso
```
timedatectl set-ntp true
```
 Confere se vc tem conexão com a internet:
```
ip a
```

Confere sincronização com repo dos pacotes
```
pacman -Sy
```
Confere discos
```
lsblk
```
Particiona conforme preferir. Recomendado usar cfdisk. GPT partition. EXEMPLO:
```
sda1 - partição para /mnt/boot, recomendado 512M
sda2 - partição para /mnt, recomendado 32G
sda3 - partição para /mnt/home, recomendado o que sobrar
```
Formatar partição do boot:
```
mkfs.fat -F32 /dev/sda1
```
Formatar outra partições:
```
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3
```
Mount...
```
mount /dev/sda2 /mnt
mkdir /mnt/{home,boot}
mount /dev/sda1 /mnt/boot
mount /dev/sda3 /mnt/home
```
Iniciar instalação
```
pacstrap /mnt base linux linux-firmware git vim amd-ucode
```
Gera filesystem table
```
genfstab -U /mnt >> /mnt/etc/fstab
```
Change to root user on the new installed system
```
arch-chroot /mnt /bin/bash
```
Muda senha do usuário root
```
passwd
```
Clona repo e executa o base.sh
