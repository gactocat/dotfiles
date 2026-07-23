# Notion の収集

Notion MCP ツールを使う。未ロードなら ToolSearch で `notion-search`, `notion-fetch`, `notion-get-users` をロードする。

## Notion の制約を先に理解する

Notion の検索は「作成者」「期間」での絞り込みが弱い。全文検索が主で、ページの created_by / last_edited_by はページを個別に fetch しないと分からないことが多い。したがって Notion は **best-effort** で収集し、網羅性を期待しない。

## 手順

1. `notion-get-users` でメンバーの Notion ユーザーを特定する。
2. チームが使っているスペース・データベースを起点に探す。ユーザー (マネージャー) にチームの主要ページ (プロジェクト管理 DB、ドキュメントスペースなど) を聞くのが早い。データベースがあれば `notion-query-data-sources` / `notion-query-database-view` で作成者・更新日時によるフィルタが使えることがある。
3. `notion-search` でメンバー名・担当プロジェクト名を検索し、ヒットしたページを `notion-fetch` で開いて created_by / last_edited_by / last_edited_time を確認する。
4. 議事録運用があるなら `notion-query-meeting-notes` も試す。

## 見るもの

- 期間内に作成したドキュメント・プロジェクトページ
- 担当タスク・プロジェクトの進行記録 (DB のアサイン + ステータス変化)

## 注意

- 収集できた範囲が狭くても無理に埋めない。「Notion は検索制約により把握できた範囲のみ」とレポートの制約事項に書く。
- 他サービス (GitHub の PR、esa の設計書) で既に拾った仕事の重複 evidence になっていることが多い。その場合はハイライト側に束ねる。
