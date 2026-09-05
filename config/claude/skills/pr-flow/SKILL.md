---
name: pr-flow
description: PR を作成する前に必ず通す一連のフロー。セルフレビュー (review-patch) → crit によるユーザーレビュー依頼 → approve 確認 → PR 作成 の順に進める。「PR を作って」「PR 出して」「プルリクお願い」と依頼されたとき、および実装が完了して PR 作成に移ろうとするときに使う。
---

# PR Flow

実装が終わってから PR を出すまでの手順を固定する。目的は、レビューされていない変更が PR として外に出るのを防ぐこと。

**REQUIRED SUB-SKILL:**

- `review-patch` — Step 1 のセルフレビュー本体
- `commit-ja` — Step 0 / Step 1 / Step 2 で発生するコミット
- `gh-ops` — `gh` を使う操作 (push、PR 作成、PR 情報の取得)

## 適用範囲

以下のいずれかに該当したら、このフローに入る。

- ユーザーから PR 作成を依頼された
- 実装タスクが完了し、次のアクションが PR 作成になる

### 例外

以下の場合はフローを省略してよい。ただし**省略したことを必ずユーザーに伝える**。

- ユーザーが明示的にスキップを指示した (「レビューは要らないので PR まで作って」等)
- typo 修正、設定値 1 行変更など、レビューする論点が存在しない極小の変更

判断に迷う場合は省略せず、フローを回す。

### Personal repositories owned by gactocat

If the repository is detected as `gactocat` (see "Account selection" in `gh-ops`) and gactocat is the owner, do not open a PR by default. Commit with `commit-ja` (English message per its exception) and push directly to `main`.

```bash
git push origin HEAD:main
```

Open a PR only when the user explicitly asks for one, or when the repository is owned by someone else. Tell the user when you took this path.

## Step 0: 変更をコミットする

`review-patch` のデフォルト対象は `main...HEAD` (コミット済みの差分) なので、先にコミットを済ませる。

未コミットの変更が残っている場合は `commit-ja` に従ってコミットする。

```bash
git status --short
```

この時点では push しない。push は approve 後の Step 3 で行う。

## Step 1: セルフレビューと修正

`review-patch` を実行し、現在のブランチの差分をレビューする。

- `review-patch` の「author = 現在のユーザー」分岐に入るので、レビュー結果を提示したうえで修正の要否をユーザーに確認する
- 修正を行った場合は、その修正も `commit-ja` に従ってコミットする
- 指摘ゼロで終わった場合もその旨を明示して Step 2 に進む

このステップを飛ばして Step 2 に進まない。

## Step 2: crit でユーザーにレビューを依頼する

`crit:crit` を実行し、ユーザーによるレビューを受ける。

- `crit` は background 実行し、ユーザーが「Finish Review」を押すまでブロックする。途中で先に進まない
- 起動時に表示されるレビュー URL をそのままユーザーに伝える
- コメントが付いたら `crit:crit` の手順に従って修正し、返信する。`--resolve` は付けない (解決判定はレビュアーの権限)
- 修正が発生したらコミットし、次のラウンドを開始する

### approve の判定

crit の stderr に出る `approved: true` / `approved: false` を承認シグナルとして扱う。

- `approved: true` → Step 3 に進む
- `approved: false` → 未解決のコメントに対応し、再度レビューを依頼する

**approve を代理判断しない。** 指摘がゼロに見えても、コメントに全て返信済みでも、それだけで approve とみなさない。シグナルが取れない場合はユーザーに口頭で確認を取る。

## Step 3: PR を作成する

approve を確認してから、はじめて push と PR 作成を行う。

Before pushing, follow "Account selection" in `gh-ops`: detect the repository's account (`gyamada-ca` / `gactocat`) and align the `gh` active account and git identity. If you switched to `gactocat`, switch back to `gyamada-ca` after the PR is created.

```bash
git push -u origin HEAD
```

PR の作成は `gh-ops` のルールに従う。本文には以下を含める。

- 変更の意図 (`review-patch` の Phase 1a で言語化した内容を流用する)
- 影響範囲の要約
- crit レビューを通していること

## 禁止事項

- approve を確認する前に PR を作成する
- Step 1 または Step 2 を、ユーザーの明示的な指示なしに省略する
- ユーザーの代わりに approve を宣言する
