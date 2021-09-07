#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
sed -i '393s/.//' /etc/locale.gen
locale-gen
echo "LANG=pt_BR.UTF-8" >> /etc/locale.conf
echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf
echo "hyperspace" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 localhost.localdomain hyperspace" >> /etc/hosts

pacman -S --noconfirm grub efibootmgr linux-headers networkmanager base-devel sudo nvidia nvidia-utils nvidia-settings reflector rsync
 
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager

useradd -m  -g users -G wheel -s /bin/bash teixeira
echo teixeira:teixeira | chpasswd
echo "teixeira ALL=(ALL) ALL" >> /etc/sudoers.d/teixeira

printf "\e[1;32mDone! Type exit, umount -R /mnt and reboot.\e[0m"


# Reference:
# https://gitlab.com/eflinux/arch-basic/-/blob/master/install-uefi.sh
