!/usr/bin/bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


sudo pacman --noconfirm --needed -S  noto-fonts noto-fonts-emoji ttf-dejavu ttf-fira-code
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

sudo cp -v ~/code/hyperspace/arch/dotfiles/.zshrc ~/.zshrc
sudo cp -v ~/code/hyperspace/arch/oh-my-zsh-themes/* ~/.oh-my-zsh/custom/themes/
