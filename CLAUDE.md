# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

個人のdotfilesリポジトリです。macOS環境用の設定ファイルを管理しています。

## Setup Commands

### 初期セットアップ
```bash
zsh setup.zsh  # dotfilesのクローンと初期設定
zsh deploy.zsh # シンボリックリンクの作成
zsh brew.zsh   # Homebrewパッケージのインストール (macOSのみ)
```

## Repository Structure

- **config/** - 各種アプリケーションの設定ファイル
  - nvim/ - Neovim設定 (LazyVimベース)
  - tmux/ - tmux設定とプラグイン
  - wezterm/ - WezTerm設定
  - zsh/ - zsh設定
  - starship/ - starshipプロンプト設定
  - lazygit/ - lazygit設定
  - claude/ - Claude Code設定

- **deploy.zsh** - 各設定ファイルを適切な場所にシンボリックリンクで配置
- **brew.zsh** - Homebrewによるパッケージ管理
- **Brewfile** - インストールするパッケージリスト

## Key Configuration Details

### Neovim
- LazyVimをベースにした設定
- テストフレームワーク: neotest (jest, go, plenary対応)
- プラグインは `config/nvim/lua/plugins/` に配置

### Git
- `.gitconfig` に各種エイリアス定義済み
- ghqでのリポジトリ管理 (root: ~/src)
- commit templateは `config/git/commit_template_with_prompt.txt`

### Shell Environment
- zshにzimフレームワークを使用
- fzfによるファジー検索設定済み
- starshipプロンプト使用

## Development Notes

- 日本語で会話してください
- 不要なコードコメントは追加しない
- シンボリックリンクの作成時は既存ファイルの確認を行う