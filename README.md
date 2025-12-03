# dotfiles

gactocat's dotfiles. 🦁

## setup

Exec the following to setup.

```shell
zsh -c "$(curl -L https://raw.githubusercontent.com/gactocat/dotfiles/main/setup.zsh)"
```

## Adding Homebrew packages

Homebrew packages are organized into three files in the `brew/` directory:

- `brew/Brewfile.core` - Core command-line tools (e.g., bat, eza, git, starship, tmux, zsh plugins)
- `brew/Brewfile.dev` - Development tools (e.g., awscli, fzf, gh, neovim, mise)
- `brew/Brewfile.apps` - Applications (all cask entries)

To add a new Homebrew package:

1. Edit the appropriate file in `brew/` and add the package entry (e.g., `brew "package-name"` for a formula or `cask "app-name"` for a cask)
2. Run `brew.zsh` to install the new package:

```shell
./brew.zsh
```

## Installing languages with mise

mise is included in `brew/Brewfile.dev` and available after setup.

To install a language globally:

```shell
mise use --global go@latest
mise use --global node@lts
mise use --global python@3.12
```

To use a specific version in a project (creates `.mise.toml`):

```shell
cd each-project
mise use node@20
```

To list installed languages:

```shell
mise list
```
