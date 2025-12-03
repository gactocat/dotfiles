#!/usr/bin/env zsh

set -e

DOTPATH="$HOME/dotfiles"

if [ ! -e "$DOTPATH" ]; then
    echo "Error: Directory $DOTPATH does not exist."
    exit 1
fi

cd "$DOTPATH" || exit 1

mkdir -p "$HOME/.config"
ln -fvns "$DOTPATH/config/tmux" "$HOME/.config/tmux"
ln -fvns "$DOTPATH/config/wezterm" "$HOME/.config/wezterm"

mkdir -p "$HOME/.config/starship"
ln -fvns "$DOTPATH/config/starship/starship.toml" "$HOME/.config/starship/starship.toml"

mkdir -p "$HOME/.config/nvim"
ln -fvns "$DOTPATH/config/nvim/init.lua" "$HOME/.config/nvim/init.lua"
ln -fvns "$DOTPATH/config/nvim/lua" "$HOME/.config/nvim/lua"

mkdir -p "$HOME/.config/zsh"
ln -fvns "$DOTPATH/.zshenv" "$HOME/.zshenv"
ln -fvns "$DOTPATH/config/zsh/.fzf.zsh" "$HOME/.config/zsh/.fzf.zsh"
ln -fvns "$DOTPATH/config/zsh/.zimrc" "$HOME/.config/zsh/.zimrc"
ln -fvns "$DOTPATH/config/zsh/.zshrc" "$HOME/.config/zsh/.zshrc"

mkdir -p "$HOME/.config/karabiner"
ln -fvns "$DOTPATH/config/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

mkdir -p "$HOME/.config/mise"
ln -fvns "$DOTPATH/config/mise/config.toml" "$HOME/.config/mise/config.toml"

mkdir -p "$HOME/.config/aerospace"
ln -fvns "$DOTPATH/config/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"

mkdir -p "$HOME/.config/git"
ln -fvns "$DOTPATH/config/git/commit_template_with_prompt.txt" "$HOME/.config/git/commit_template_with_prompt.txt"

mkdir -p "$HOME/.claude"
ln -fvns "$DOTPATH/config/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
ln -fvns "$DOTPATH/config/claude/settings.toml" "$HOME/.claude/settings.toml"

mkdir -p "$HOME/.codex"
ln -fvns "$DOTPATH/config/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
ln -fvns "$DOTPATH/config/codex/config.toml" "$HOME/.codex/config.toml"

mkdir -p "$HOME/Library/Application Support/lazygit"
ln -fvns "$DOTPATH/config/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"


ln -fvns "$DOTPATH/.gitconfig" "$HOME/.gitconfig"
ln -fvns "$DOTPATH/.gitignore" "$HOME/.gitignore"
