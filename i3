Ref: https://www.youtube.com/watch?v=sE3LHJ8lEss


sudo pacman -Syy reflector

sudo reflector -c Brazil -a 6 --sort rate --save /etc/pacman.d/mirrorlist

sudo pacman -Syyy

sudo pacman -S xorg xorg-xinit i3-wm i3lock i3status i3blocks dmenu terminator firefox

sudo cp /etc/X11/xinit/xinitrc ~/.xinitrc

sudo vim ~/.xinitrc

delete last 5 lines and append:

exec i3

startx

