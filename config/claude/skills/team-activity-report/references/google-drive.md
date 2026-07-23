# Google Drive の収集

Google Drive MCP ツールを使う。未ロードなら ToolSearch で `search_files`, `get_file_metadata`, `read_file_content` をロードする。

## 検索

メンバーのメールアドレスで所有ファイルを探す。search_files が Drive のクエリ構文を受け付ける場合:

```
'<email>' in owners and modifiedTime > '<開始日>T00:00:00' and modifiedTime < '<終了日>T23:59:59'
```

クエリ構文が通らないツール実装の場合は、メンバー名やチーム名で検索してから `get_file_metadata` で owner と更新日時を確認して絞り込む。`list_recent_files` は実行者視点の最近のファイルなので補助程度に使う。

## 見るもの

- 期間内に**作成**した設計書・提案書・議事録 (owner が本人 + createdTime が期間内)
- 期間内に**大きく編集**した共有ドキュメント (modifiedTime が期間内。ただし最終更新者が本人とは限らない点に注意)

ドキュメントの種類を分類する: 設計書 / 議事録 / 手順書 / 調査メモなど。重要そうなもの (共有範囲が広い、他ドキュメントから参照されている、設計判断を含む) は `read_file_content` で冒頭を読み、目的と内容を要約する。

## 注意

- 見えるのは**実行者がアクセスできるファイルだけ**。本人の限定共有ドキュメントは拾えない。レポートの制約事項に必ず書く。
- modifiedTime は誰の編集でも更新されるため、「本人が期間内に編集した」ことの証明にはならない。作成 (createdTime + owner) を主、編集は状況証拠として扱う。
- 1on1 の個人メモなど、業務成果と関係の薄いファイルはレポートに含めない。
