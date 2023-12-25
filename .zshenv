ZDOTDIR=$HOME/.config/zsh

# homebrew
export PATH="$PATH:/opt/homebrew/bin"

# asdf
. $(brew --prefix asdf)/libexec/asdf.sh
. ~/.asdf/plugins/golang/set-env.zsh # golang

# z
. `brew --prefix`/etc/profile.d/z.sh

alias v='nvim'
