---
name: assigner-autopilot
description: slack-mention-assigner (content-eng-dev-assigner、contents-engineering-ops-assigner) から自分に割り当てられたタスクを 10 分ごとに見つけ、振り分けて、調べる価値のあるものだけ worktree と Claude Code のセッションを立てて一次調査させる仕組みの操作と設定。「自動調査の台帳を見せて」「assigner autopilot の状態は」「このタスクを自動調査して」「このタスクは手で対応するので外して」「autopilot を設定したい」「自動調査が動いていない」といった依頼で使う。
---

# assigner autopilot

slack-mention-assigner の DM を本人の claude.ai Slack コネクタで検索し、割り当てられたタスクごとに一次調査のセッションを立てる。方針は esa の [Slack の assigner のタスクを自動で一次調査する仕組みの方針](https://abema.esa.io/posts/44072)。

## 仕組み

```
定期の起動 (平日 9〜20 時、10 分ごと): Orca automation の precheck、launchd、または Claude Desktop の定期タスク
  scripts/dispatch.sh → autopilot.py dispatch
    1. 検知       claude -p (Haiku、Slack の検索だけ許可) で assigner の DM を集める
    2. 突き合わせ  そろったリマインドから消えたもの、解除の DM、スレッドの close で閉じる
    3. 振り分け    claude -p (Sonnet) がスレッドを読み、investigate / question / human に分けてブリーフを書く
    4. 起動       上限の内側なら worktree を作り、scripts/run-task.sh を動かす
    5. 片付け     閉じたタスクのセッションが 30 分以上動いていなければ閉じる

scripts/run-task.sh → autopilot.py run-task
    一次調査  claude -p --session-id (Opus、予算と時間の上限、書き込みは guard.py と拒否ルールで止める) → report.md
    続き     claude --resume <session id> (Orca ならそのタブ、ほかは tmux か通知のコマンド)
```

- 書き込みはしない: Slack への投稿・リアクション・下書き、assigner の操作、GitHub への書き込み、本番の変更。返信は報告書の文案まで。一次調査には `scripts/guard.py` (PreToolUse hook) と `--disallowedTools` を付ける
- 始めた時点 (設定の `go_live`) より前の割り当ては「既存」として登録し、自動では立てない
- 依頼者が本人、P5、秘書の台帳 (設定の `secretary_ledger`) にスレッドがあるものは見送る

## ファイル

| 場所 | 中身 |
| --- | --- |
| `~/.config/assigner-autopilot/config.json` | 個人の設定 (`config.example.json` を参照)。環境変数 `ASSIGNER_AUTOPILOT_CONFIG` で別のファイルを指せる |
| `<state_dir>/state.json` | タスクの状態、最後に検知が通った時刻、リマインドのスナップショット、日ごとの費用 |
| `<state_dir>/ledger.md` | 台帳 (人が読む)。dispatch のたびに書き直す |
| `<state_dir>/tasks/<key>/` | `triage.json`、`brief.md`、`report.md`、`result.json` |
| `<state_dir>/dispatch.log`、`events.jsonl` | 動きの記録と、状態の変化の記録 |

`<key>` は TaskId の `#` を `-` に、`.` を消したもの (例 `C041EEB1S8M-1792031096573119`)。

## 手で動かす

```bash
A=~/.claude/skills/assigner-autopilot/scripts/autopilot.py
/usr/bin/python3 $A list                 # 台帳を表示
/usr/bin/python3 $A status               # 検知の最終成功、失敗の回数、今日の費用、状態ごとの件数
/usr/bin/python3 $A run <TaskId|URL|key>    # 自動では立てなかったタスクを調べさせる (振り分けからやり直し、上限の日数と費用は無視)
/usr/bin/python3 $A skip <TaskId|URL|key>   # 見送る
/usr/bin/python3 $A claim <TaskId|URL|key>  # 手で対応する (自動では立てない)
/usr/bin/python3 $A retry <TaskId|URL|key>  # 失敗したものをやり直す
DRY_RUN=1 FORCE=1 ~/.claude/skills/assigner-autopilot/scripts/dispatch.sh   # 試し実行 (状態を保存しない、セッションを立てない)
```

`run` などは状態を変えるだけで、実際に立てるのは次の dispatch (10 分以内)。すぐ動かすときは `FORCE=1 scripts/dispatch.sh`。

## 設定する (新しく使う人)

前提: Claude Code の CLI を claude.ai のアカウントでログインしていること (`claude auth status` の `authMethod` が `claude.ai`)、claude.ai の Slack コネクタを認証していること、gh、AWS の PERMAN のプロファイル (`set-aws-perman-auth`)、content-engineering のチェックアウト。

1. `/usr/bin/python3 ~/.claude/skills/assigner-autopilot/scripts/autopilot.py setup` で設定ファイルを作る。`go_live` は作った時刻になる
2. 設定ファイルを直す
   - `owner_name`、`self_user_ids` (自分の Slack ID。Grid 移行で複数あれば全部。依頼者が本人のタスクを見送るのに使う)
   - `launcher`: Orca を使うなら `orca` と `orca_repo_id` (`orca repo list --json` の content-engineering の id)。使わないなら `plain` と `worktree_root`
   - `permission_mode`: ABM Develop Experimental なら `auto` も選べる。ABM Develop は auto mode が無効なので `dontAsk` のまま (許可リストは `extra_allowed_tools` で足す)
   - `limits`: 最初は `max_parallel` 1、`max_per_day` 3
3. 試し実行で検知を確かめる: `DRY_RUN=1 FORCE=1 ~/.claude/skills/assigner-autopilot/scripts/dispatch.sh`。`detect ok: N messages` と、今の担当が「existing」で並ぶこと
4. 定期の起動を登録する (本人に内容を見せて確かめてから)
   - Orca: `orca automations create --name "assigner autopilot" --trigger "*/10 9-19 * * 1-5" --timezone Asia/Tokyo --provider claude --prompt "使わない (precheck が必ず非 0 で終わる)" --precheck "/bin/bash $HOME/.claude/skills/assigner-autopilot/scripts/dispatch.sh" --precheck-timeout 300 --workspace path:<content-engineering のチェックアウト> --workspace-mode existing --fresh-session --missed-run-grace-minutes 30 --enabled --json`
   - launchd: `launchd/assigner-autopilot.plist.tmpl` の `__HOME__` を置き換えて `~/Library/LaunchAgents/com.<名前>.assigner-autopilot.plist` に置き、`launchctl bootstrap gui/$(id -u) <plist>`。止めるときは `launchctl bootout gui/$(id -u)/com.<名前>.assigner-autopilot`
   - Claude Desktop の定期タスク (Local): 指示を「`/bin/bash ~/.claude/skills/assigner-autopilot/scripts/dispatch.sh` を実行し、出力の最後の行だけを 1 行で報告する」、モデルを Haiku、間隔を 15〜30 分にする。最初に「Run now」で Bash の許可を「always allow」にそろえる

## 罠

- launchd や Orca の precheck は環境変数が少ない。`claude` は `USER` が無いとキーチェーンのログイン情報を読めず「Not logged in」になる。Orca の managed account は `CLAUDE_CONFIG_DIR` を `~/Library/Application Support/orca/claude-profiles/selected-host` から読む。どちらも `autopilot.py` の `claude_env` で補っている
- Slack コネクタの `slack_read_channel` は bot の DM の本文を空で返す。検知は `slack_search_public_and_private` (`include_bots: true`) を使う
- リマインドは担当が 0 件、sleep 中、休日には来ない。来ないことを close と読まず、リマインドの時刻を過ぎても新しいリマインドが無いタスクはスレッドで close を確かめる (`verify_open`)
- Grid 移行で同じ人に複数の Slack ID が出る。「誰の担当か」は ID ではなく、本人と bot の DM に届いたかで決める
- 依頼が短い文と画像だけのことが多い。振り分けと一次調査には `slack_read_file` を許している
- 費用は claude -p の `total_cost_usd` (定価換算) で数える。個人の利用上限に当たると、ほかの仕事も止まる

## 止める

- Orca: `orca automations edit --id <id> --disabled`
- launchd: `launchctl bootout gui/$(id -u)/com.<名前>.assigner-autopilot`
- 動いている一次調査を止めるのは、そのタブを閉じる (Orca) か、プロセスを止める (plain)。次の dispatch で「セッションが消えた」として扱われ、3 回で諦める。続けたくないなら `skip`
