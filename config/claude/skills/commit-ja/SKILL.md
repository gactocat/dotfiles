---
name: commit-ja
description: ステージ済みの変更から日本語の Conventional Commits 形式のコミットメッセージを作成する。ユーザーが「コミットして」「コミットメッセージを作って」と依頼したときに使う。
---

# commit-ja

ステージされた変更を確認し、日本語の Conventional Commits 形式でコミットする。

## 手順

1. `git status` と `git diff --staged` で変更内容を確認する。
2. 何もステージされていなければ、ユーザーに `git add` が必要か確認する。
3. 変更の意図を読み取り、以下の形式でメッセージを作成する。

```
<type>(<scope>): <要約（日本語・50 文字以内）>

<本文（任意・なぜこの変更が必要かを説明）>
```

- `type`: feat / fix / docs / style / refactor / test / chore など
- `scope`: 変更対象（任意）
- 要約は和欧文字間に半角スペースを入れる

4. `git commit` を実行する。
