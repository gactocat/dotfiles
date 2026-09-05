# CLAUDE.md

## PR 作成前のフロー

PR は、レビューを通してから作る。実装が終わったら、または PR 作成を依頼されたら、以下の順に進めること。

1. `review-patch` でセルフレビューし、指摘を修正する
2. `crit:crit` でユーザーにレビューを依頼する
3. ユーザーが approve したら PR を作成する

approve を確認する前に PR を作らない。approve をこちらで代理判断しない。
手順の詳細と例外条件は `pr-flow` skill に従う。

## Personal development (gactocat)

Two github.com accounts are in use: `gyamada-ca` for work and `gactocat` for personal projects. Detect the account from the `origin` remote host as described in "Account selection" in the `gh-ops` skill. Work repositories follow the normal flow. In `gactocat` repositories:

- Write code comments, commit messages, and Markdown in concise English. Conversation with the user stays in Japanese.
- When gactocat owns the repository, do not open a PR by default. Commit and push directly to `main`. Open a PR only when asked.

## Markdown 整形ルール

文章を生成するときは、以下を**必ず**守ること。これは好みではなく厳守すべき仕様である。

### 文字間スペース

- 和文と欧文・数字の境界に半角スペースを入れる
  - 良い例: `これは Claude Code の設定です`、`合計 3 件`
  - 悪い例: `これはClaude Codeの設定です`、`合計3件`
- ただし句読点や記号 (、。「」() など) の隣にはスペースを入れない

### 見出し

- 見出しに `1.` `2.` などの通し番号を付けない
  - 良い例: `## セットアップ手順`
  - 悪い例: `## 1. セットアップ手順`
- 番号付きの手順を示したいときは、見出しではなく本文中の番号付きリストで表現する

### 区切り線

- `---` などの水平区切り線 (horizontal rule) を使わない
- セクションの区切りは見出しと空行だけで表現する

### その他

- 絵文字は明示的に求められない限り使わない
- 装飾は控えめにし、内容で伝える
