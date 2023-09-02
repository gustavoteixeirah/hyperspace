!/usr/bin/bash

git config --global core.editor "vim"
git config --global user.email "contact@gustavoteixeira.dev"
git config --global user.name "Gustavo Teixeira"
git config --global url.git@github.com:.insteadOf https://github.com/
git config --global --add --bool push.autoSetupRemote true 
git config --global pull.rebase false


ssh-keygen -t ed25519 -C "contact@gustavoteixeira.dev"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

cat ~/.ssh/id_ed25519.pub

echo Have you copied the public key and pasted into github ssh section?

read hasCopied

# Code repositories
mkdir -p ~/code
cd ~/code
git clone git@github.com:gustavoteixeirah/Tools.git

mkdir -p ~/code/KodeGT
cd ~/code/KodeGT
git clone git@github.com:KodeGT/webapp.git
git clone git@github.com:KodeGT/studybuddy.git
git clone git@github.com:KodeGT/qa.git
git clone git@github.com:KodeGT/infra.git
git clone git@github.com:KodeGT/docs.git
