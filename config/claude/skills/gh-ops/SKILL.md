---
name: gh-ops
description: GitHub CLI（gh）を利用するタスクで使用する。リポジトリ、Issue、PR、レビュー、Checks、Actions、Release、認証、gh api を扱う場合に読み込む。
---

# GitHub CLI Operations

`gh` コマンドで GitHub の情報を取得・変更するときの共通ルール。

## 基本方針

- 実行対象のリポジトリを最初に確認する。カレントリポジトリ以外を操作するときは `--repo OWNER/REPO` を明示する。
- Identify which account (`gyamada-ca` / `gactocat`) the target repository belongs to, and align the `gh` active account and git identity with it. See "Account selection" below.
- 読み取りでは、人間向け表示の解析を避け、利用可能なら `--json` と `--jq` を使う。
- フラグや出力項目が不明な場合は、推測せず `gh <command> --help` で確認する。
- `gh auth status` が token invalid / `401` の場合、macOS Keychain を参照できない環境も考慮し、後述の認証手順を確認する。
- 作成・編集・コメント・レビュー・close・merge・delete・workflow dispatch など、GitHub の状態を変える操作は、ユーザーが依頼した範囲だけ実行する。
- 変更操作の後は対応する `view`、`list`、`api` などで結果を再取得し、反映内容を確認する。
- token、credential、認証ヘッダをコマンド出力・ログ・一時ファイル・会話へ露出させない。

## Account selection

Two github.com accounts are registered. Each repository belongs to exactly one of them; never mix them.

| Account      | Purpose  | SSH host              | Remote URL example                          |
| ------------ | -------- | --------------------- | ------------------------------------------- |
| `gyamada-ca` | Work     | `github.com`          | `git@github.com:ORG/REPO.git`               |
| `gactocat`   | Personal | `gactocat.github.com` | `git@gactocat.github.com:gactocat/REPO.git` |

`gactocat.github.com` is an SSH host alias defined in `~/.ssh/config`. It connects to github.com with the gactocat key.

### How to decide

Use the host of the `origin` remote URL.

```bash
git remote get-url origin
```

- Host `gactocat.github.com` → `gactocat`
- Host `github.com` → `gyamada-ca`
- Anything else (https URL, other host): do not guess from the owner name. Ask the user.

### gh active account

The `gh` active account is global and does not follow the repository. `git push` works regardless because SSH picks the key by host, but `gh pr create`, `gh api`, and other API calls run as the active account. With the wrong account they fail with errors such as `must be a collaborator`, which is easy to misread because the push succeeded.

Before any `gh` operation that changes state in the target repository (creating or editing PRs and issues, comments, reviews, merge, etc.), check the active account.

```bash
gh auth status
```

If it does not match the repository's account, confirm with the user, then switch.

```bash
gh auth switch --user gactocat
```

- `gyamada-ca` is the default active account. After switching to `gactocat`, switch back with `gh auth switch --user gyamada-ca` as soon as the operation is done.
- The active account is global. While switched, `gh` in other terminals and sessions is affected too. Never end a session while switched.
- Do not use the `GH_TOKEN` procedure from "Keychain を参照できない環境での認証" as a way to pick an account.

### Git commit identity

`user.name` / `user.email` are not set globally. Each repository keeps them in its local `.git/config`. Before committing, check that they match the repository's account.

```bash
git config user.name
git config user.email
```

- If unset or set to the other account, confirm with the user and set them locally. Never use `--global`.
- `user.name` is the account name (`gyamada-ca` / `gactocat`). `user.email` is the address registered on GitHub for that account.

### Clone and remote setup

- Clone personal repositories and add their remotes as `git@gactocat.github.com:gactocat/REPO.git`.
- `git@github.com:` and https URLs authenticate with the gyamada-ca key (`.gitconfig` rewrites https to `git@github.com:` via `insteadOf`). Using them for a personal repository fails to authenticate and breaks the host-based detection above.
- `ghq get` and `gh repo clone` produce plain `github.com` URLs, so they are for work repositories. For personal repositories use `git clone` with the alias, or fix the URL afterwards with `git remote set-url origin`.

### Conventions in gactocat repositories

Repositories detected as `gactocat` follow the personal development rules in `~/.claude/CLAUDE.md`: write code comments, commit messages, and Markdown in concise English, skip the `review-patch` / `crit:crit` review flow, and push to `main` instead of opening a PR when gactocat owns the repository.

## クイックリファレンス

| 目的               | コマンド例                                                                     |
| ------------------ | ------------------------------------------------------------------------------ |
| リポジトリ確認     | `gh repo view --json nameWithOwner,url,defaultBranchRef`                       |
| Issue の取得       | `gh issue view <番号> --json number,title,body,state,url`                      |
| PR の取得          | `gh pr view <番号> --json number,title,body,state,url,headRefName,baseRefName` |
| Actions の確認     | `gh run list` / `gh run view <ID> --log-failed`                                |
| REST / GraphQL API | `gh api ...` / `gh api graphql ...`                                            |

## 構造化データとページネーション

```bash
gh pr view 123 --json number,title,state,url --jq '{number, title, state, url}'
```

一覧 API では取りこぼしを避けるため、複数ページになり得る場合は `--paginate` を使う。レスポンスを1つの配列へまとめる必要がある場合は `--slurp` も使う。

```bash
gh api --paginate 'repos/{owner}/{repo}/issues?state=all&per_page=100'
```

## 変更操作

高影響な操作（PR の merge、Issue/PR の close、Release の削除、workflow dispatch など）は、ユーザーの明示的な依頼がある場合にだけ実行する。

## Keychain を参照できない環境での認証

`gh auth status` が token invalid / `401` になり、macOS Keychain を参照できない場合でも、Git credential helper が有効な GitHub credential を返すときだけ次を使う。token は標準出力・ファイル・親シェルへ残さず、対象の `gh` プロセスにだけ渡す。

```sh
(
  set +x
  unset GH_TOKEN GITHUB_TOKEN
  token=$(printf 'protocol=https\nhost=github.com\n\n' | git credential fill | sed -n 's/^password=//p')

  if [ -z "$token" ]; then
    printf '%s\n' 'GitHub credential not found' >&2
    exit 1
  fi

  GH_TOKEN="$token" command gh pr view 1234
)
```

- 最終行の `gh pr view 1234` を実行したい `gh` コマンドへ置き換える。
- `gh auth setup-git` は Git が `gh` の credential を使うための設定であり、この用途には使わない。
- `echo "$token"`、`gh auth token`、`gh auth status --show-token`、`export GH_TOKEN=...`、`gh auth login --insecure-storage` は使わない。

## autolink の回避

GitHub は本文中の `#数字` を自動的に Issue/PR へのリンクに変換する。**意図しないリンクを防ぐため、`#数字` は実際の Issue/PR を参照する場合にのみ使う。**

順序・連番・ラベルとして番号を振りたい場合は `#` を付けない:

| 避けるべき表記             | OK                       |
| -------------------------- | ------------------------ | ---- | ---- | ------------------- | --- | --- | ---- | ---- | --- |
| `問題 #1` / `sub-issue #2` | `問題 1` / `sub-issue 2` |
| ` | #                        | 問題 | 影響 | `（テーブルヘッダ） | ` | No. | 問題 | 影響 | `   |
| `ステップ #3 で失敗`       | `ステップ 3 で失敗`      |

Closing keywords（`Closes #1234` 等）や意図的な Issue/PR 参照は autolink 回避の対象外。

## Closing keywords

PR 本文で Issue との紐付けに使うキーワード。

| 用途                        | キーワード                      | Development 自動紐付け | マージ時 Issue クローズ |
| --------------------------- | ------------------------------- | ---------------------- | ----------------------- |
| この PR で Issue を解決する | `Closes` / `Fixes` / `Resolves` | ○                      | ○                       |
| 参照のみ（クローズしない）  | `Refs`                          | ×                      | ×                       |

- closing keyword は PR 本文の冒頭に記載する（`Closes #1234`）
- 参照のみで Development に紐付けたい場合は、closing keyword は使わず、PR 作成後に `gh pr edit` や Web UI から手動でリンクする

## AI Generated バッジ

AI エージェントが作成・投稿するコンテンツには `![AI Generated](https://img.shields.io/badge/AI-Generated-blueviolet)` バッジを付与する。

- **PR 本文**: 末尾に付与
- **レビューコメント・返信**: 本文冒頭に付与

## コンテンツの渡し方

### `gh pr create` / `gh issue create`

本文は一時ファイルに書き出し、`--body-file` で渡す。`--body "..."` はシェル展開や引用符の影響で Markdown が壊れやすい。

- **本文中のバックティックを絶対にエスケープしない**（`` \` `` と書かない）
- 投稿後、エスケープ済みバックティックが残っていないか確認する:

  ```bash
  gh pr view <番号> --json body -q .body | grep -c '\\`'
  ```

### `gh api`

`-f` オプションは感嘆符をバックスラッシュエスケープするため、`--input` で JSON を stdin 経由で渡す。
