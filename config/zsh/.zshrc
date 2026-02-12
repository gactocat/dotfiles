HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

alias l='eza -l --icons'
alias la='eza -la --icons'

alias v='nvim'
alias g='git'
alias lg='lazygit'

source ${ZDOTDIR:-${HOME}}/.zsh-function

source ${ZDOTDIR:-${HOME}}/.fzf.zsh

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  autoload -Uz compinit
  compinit
fi

export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# z
. `brew --prefix`/etc/profile.d/z.sh

# mise
eval "$(mise activate zsh)"