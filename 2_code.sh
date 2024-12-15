!/usr/bin/bash

git config --global core.editor "nvim"
git config --global user.email "10344032+gustavoteixeirah@users.noreply.github.com"
git config --global user.name "Gustavo Teixeira"
git config --global url.git@github.com:.insteadOf https://github.com/
git config --global --add --bool push.autoSetupRemote true 
git config --global pull.rebase false


ssh-keygen -t ed25519 -C "10344032+gustavoteixeirah@users.noreply.github.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

cat ~/.ssh/id_ed25519.pub


