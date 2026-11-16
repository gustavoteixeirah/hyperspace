# Powerlevel10k instant prompt (deve ficar no topo do ~/.zshrc)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git z fzf sudo kubectl docker docker-compose aws npm extract copypath copyfile
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search   # deve vir depois do syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.local/bin:$PATH"

# --- histórico + autosuggestions ---
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS SHARE_HISTORY INC_APPEND_HISTORY
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
bindkey '^ ' autosuggest-accept   # Ctrl+Espaço aceita a sugestão inteira

# --- history-substring-search: setas ↑/↓ filtram pelo que já foi digitado ---
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# Segredos e coisas específicas da máquina (NÃO versionado)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Powerlevel10k config (rode `p10k configure` para personalizar)
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
