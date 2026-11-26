#!/usr/bin/env bash
# Acesso remoto ao Legion (notebook) a partir do hyperspace: Sunshine no Legion, Moonlight aqui,
# com o Legion desenhando numa tela ultrawide virtual 3440x1440. Detalhes: docs/legion-remote-desktop.md
#
# Roda NO HYPERSPACE. Pede a senha do sudo daqui (pacman) e a do Legion (via ssh -t).
#   bash 9_legion_remote.sh            # IP padrão <ip-da-lan>
#   LEGION=usuario@ip-do-legion bash 9_legion_remote.sh
set -euo pipefail
REPO="$(cd "$(dirname "$0")" && pwd)"
L="$REPO/dotfiles/legion"
LEGION="${LEGION:-teixeira@<ip-da-lan>}"
HOST="${LEGION#*@}"

echo "== 1. SSH por chave (alias 'legion')"
[ -f "$HOME/.ssh/id_ed25519" ] || ssh-keygen -t ed25519 -N "" -f "$HOME/.ssh/id_ed25519"
ssh -o BatchMode=yes "$LEGION" true 2>/dev/null || ssh-copy-id -o StrictHostKeyChecking=accept-new "$LEGION"
touch "$HOME/.ssh/config"; chmod 600 "$HOME/.ssh/config"
grep -q '^Host legion$' "$HOME/.ssh/config" || printf '\nHost legion\n    HostName %s\n    User %s\n    IdentityFile ~/.ssh/id_ed25519\n' "$HOST" "${LEGION%@*}" >>"$HOME/.ssh/config"

echo "== 2. Arquivos para o Legion"
ssh legion 'mkdir -p /tmp/legion-remote ~/.local/bin ~/.config/i3/config.d ~/.config/sunshine'
scp -q "$L"/xorg/*.conf "$L"/edid/asus-xg35v.edid "$L"/greetd/initial_session.toml legion:/tmp/legion-remote/
scp -q "$L/bin/legion-display" legion:.local/bin/legion-display
scp -q "$L/i3/remote.conf" legion:.config/i3/config.d/remote.conf
scp -q "$L/sunshine/sunshine.conf" legion:.config/sunshine/sunshine.conf

echo "== 3. Instalação no Legion (pede a senha do sudo de lá)"
ssh -t legion 'set -e
chmod 755 ~/.local/bin/legion-display
command -v sunshine >/dev/null || yay -S --needed sunshine-bin
sudo pacman -S --needed xorg-xinput
sudo install -D -m 644 /tmp/legion-remote/asus-xg35v.edid /etc/X11/edid/asus-xg35v.edid
sudo install -m 644 /tmp/legion-remote/20-nvidia-virtual-ultrawide.conf /tmp/legion-remote/30-sunshine-keyboard-us.conf /etc/X11/xorg.conf.d/
echo uinput | sudo tee /etc/modules-load.d/uinput.conf >/dev/null
G=/etc/greetd/cosmic-greeter.toml
if ! grep -q "^\[initial_session\]" $G; then
  sudo cp -n $G $G.bak-claude
  { echo; cat /tmp/legion-remote/initial_session.toml; } | sudo tee -a $G >/dev/null
fi
# o $mod do i3 do Legion é Alt (Caps é do hyperspace; Moonlight não repassa a tecla Windows)
grep -q "^set \$mod Mod1$" ~/.config/i3/config || { cp ~/.config/i3/config ~/.config/i3/config.bak-claude-mod; sed -i "s/^set \$mod Mod[0-9]$/set \$mod Mod1/" ~/.config/i3/config; }
grep -q "^include ~/.config/i3/config.d/\*.conf" ~/.config/i3/config || echo "include ~/.config/i3/config.d/*.conf" >> ~/.config/i3/config
DISPLAY=:0 i3 -C -c ~/.config/i3/config
echo "Credenciais do painel web do Sunshine (https://localhost:47990):"
read -rp "usuário: " u; read -rsp "senha: " p; echo; sunshine --creds "$u" "$p"
echo "Pronto. Reinicie o Legion (ou encerre a sessão gráfica e reinicie o cosmic-greeter.service)."'

echo "== 4. Moonlight no hyperspace"
sudo pacman -S --needed moonlight-qt
conf="$HOME/.config/Moonlight Game Streaming Project/Moonlight.conf"
if pgrep -x moonlight >/dev/null; then echo "Feche o Moonlight e rode de novo para gravar as configurações."; exit 0; fi
mkdir -p "$(dirname "$conf")"; [ -f "$conf" ] || printf '[General]\n' >"$conf"
grep -q '^\[General\]' "$conf" || sed -i '1i [General]' "$conf"
grep -vE '^(#|$)' "$L/moonlight.conf" | while IFS== read -r k v; do
  sed -i "/^$k=/d" "$conf"
  sed -i "/^\[General\]/a $k=$v" "$conf"
done
echo "Feito. Abra o Moonlight, adicione o host $HOST e pareie (ver docs/legion-remote-desktop.md)."
