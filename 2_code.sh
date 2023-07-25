!/usr/bin/bash


# Code repositories
mkdir -p ~/code
cd code
git clone git@github.com:gustavoteixeirah/Tools.git

mkdir -p ~/KodeGT
cd KodeGT
git clone git@github.com:KodeGT/webapp.git
git clone git@github.com:KodeGT/studybuddy.git
git clone git@github.com:KodeGT/qa.git
git clone git@github.com:KodeGT/infra.git
git clone git@github.com:KodeGT/docs.git

# sudo pacman --noconfirm --needed -S zsh zsh-completions
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

# cp ~/code/hyperspace/dotfiles/.zshrc ~/.zshrc
