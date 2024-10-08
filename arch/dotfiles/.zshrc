export GPG_TTY=$(tty)
export ZSH="/home/teixeira/.oh-my-zsh"

ZSH_THEME="fire"

plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
)

source $ZSH/oh-my-zsh.sh
eval "$(zoxide init --cmd cd zsh)"