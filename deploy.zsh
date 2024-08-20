#!/usr/bin/env zsh

set -e

DOTPATH="$HOME/dotfiles"

if [ ! -e "$DOTPATH" ]; then
    echo "Error: Directory $DOTPATH does not exist."
    exit 1
fi

cd "$DOTPATH" || exit 1

mkdir -p "$HOME/.config"
ln -fvns "$DOTPATH/.config/gitui" "$HOME/.config/gitui"
ln -fvns "$DOTPATH/.config/tmux" "$HOME/.config/tmux"
ln -fvns "$DOTPATH/.config/wezterm" "$HOME/.config/wezterm"

mkdir -p "$HOME/.config/nvim"
ln -fvns "$DOTPATH/.config/nvim/init.lua" "$HOME/.config/nvim/init.lua"
ln -fvns "$DOTPATH/.config/nvim/lua" "$HOME/.config/nvim/lua"

mkdir -p "$HOME/.config/zsh"
ln -fvns "$DOTPATH/.zshenv" "$HOME/.zshenv"
ln -fvns "$DOTPATH/.config/zsh/.fzf.zsh" "$HOME/.config/zsh/.fzf.zsh"
ln -fvns "$DOTPATH/.config/zsh/.zimrc" "$HOME/.config/zsh/.zimrc"
ln -fvns "$DOTPATH/.config/zsh/.zshrc" "$HOME/.config/zsh/.zshrc"

mkdir -p "$HOME/.config/aerospace"
ln -fvns "$DOTPATH/.config/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"

mkdir -p "$HOME/.config/git"
ln -fvns "$DOTPATH/.config/git/commit_template_with_prompt.txt" "$HOME/.config/git/commit_template_with_prompt.txt"

mkdir -p "$HOME/Library/Application Support/lazygit"
ln -fvns "$DOTPATH/.config/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"


ln -fvns "$DOTPATH/.gitconfig" "$HOME/.gitconfig"
ln -fvns "$DOTPATH/.gitignore" "$HOME/.gitignore"
