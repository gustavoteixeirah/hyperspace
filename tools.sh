
curl https://mise.run | sh

echo "eval \"\$(/home/teixeira/.local/bin/mise activate zsh)\"" >> "/home/teixeira/.zshrc"

mise use -g python@3.11 java@21-openjdk node@22 uv maven gradle pnpm
