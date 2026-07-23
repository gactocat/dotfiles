# GitHub の収集

`gh` CLI を使う。対象組織の GitHub org 全体を検索する。複数のリポジトリに活動が分散している可能性があるため、最初からリポジトリを絞らない。

## 定量データの一括取得

まず同梱スクリプトを実行する。

```bash
bash <このスキルのディレクトリ>/scripts/github.sh <GitHubユーザー名> <開始日 YYYY-MM-DD> <終了日 YYYY-MM-DD> <GitHub org>
```

出力 (JSON) に含まれるもの:

- 期間内に作成した PR の一覧 (タイトル、リポジトリ、状態、URL、作成日)
- 期間内にマージされた PR の一覧
- レビューした PR の一覧 (自分が作成したものは除外して数えること)
- 関与した Issue の一覧

スクリプトが使えない環境では、中身と同じ以下のコマンドを個別に実行する。

```bash
gh search prs --owner=<github-org> --author=<user> --created=<start>..<end> --limit 200 \
  --json title,repository,state,url,createdAt,closedAt
gh search prs --owner=<github-org> --author=<user> --merged-at=<start>..<end> --limit 200 \
  --json title,repository,url,closedAt
gh search prs --owner=<github-org> --reviewed-by=<user> --updated=<start>..<end> --limit 200 \
  --json title,repository,author,url,updatedAt
gh search issues --owner=<github-org> --involves=<user> --updated=<start>..<end> --limit 100 \
  --json title,repository,url,state,updatedAt
```

コミット数は主要リポジトリ (PR 一覧から特定できる) ごとに取る。

```bash
gh api "repos/<github-org>/<repo>/commits?author=<user>&since=<start>T00:00:00Z&until=<end>T23:59:59Z&per_page=100" \
  --paginate --jq 'length'
```

## 深掘り

定量一覧から影響の大きそうな PR を選んで中身を読む。選ぶ基準: コメント数が多い、差分が大きい、リリースや障害対応に関わる、複数リポジトリにまたがる仕事の一部。

```bash
gh pr view <URL> --json title,body,additions,deletions,comments,reviews,files
```

読み取ること:

- PR の目的と解決した課題 (body と関連 Issue から)
- レビューでの議論の深さ (設計判断をリードしたか、指摘にどう応えたか)
- **レビュアーとしての貢献**: reviewed-by で拾った他人の PR のうちコメント数が多いものを 2〜3 件開き、指摘の質 (バグ発見、設計改善提案、丁寧な説明) を見る。これはコラボレーションの evidence になる

## 注意

- `gh search` は 1 リクエスト最大 1000 件・`--limit` は 200 が上限に近い。200 件を超える場合は期間を分割する。
- 検索はデフォルトブランチへの squash マージ後のコミット authorship に依存するため、コミット数は目安として扱い、PR 数を主指標にする。
- private リポジトリでも自分 (実行者) に権限があれば検索に含まれる。逆に権限のないリポジトリの活動は見えない。
