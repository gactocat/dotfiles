#!/usr/bin/env bash
# GitHub 上の活動を一括取得する。
# 使い方: github.sh <user> <start YYYY-MM-DD> <end YYYY-MM-DD> <org>
set -euo pipefail

if [[ $# -lt 4 ]]; then
  echo "usage: $0 <github-user> <start YYYY-MM-DD> <end YYYY-MM-DD> <org>" >&2
  exit 1
fi

user="$1"
start="$2"
end="$3"
org="$4"

created_prs=$(gh search prs --owner="$org" --author="$user" --created="${start}..${end}" \
  --limit 200 --json title,repository,state,url,createdAt,closedAt)
merged_prs=$(gh search prs --owner="$org" --author="$user" --merged-at="${start}..${end}" \
  --limit 200 --json title,repository,url,closedAt)
reviewed_prs=$(gh search prs --owner="$org" --reviewed-by="$user" --updated="${start}..${end}" \
  --limit 200 --json title,repository,author,url,updatedAt)
involved_issues=$(gh search issues --owner="$org" --involves="$user" --updated="${start}..${end}" \
  --limit 100 --json title,repository,url,state,updatedAt)

jq -n \
  --arg user "$user" --arg start "$start" --arg end "$end" --arg org "$org" \
  --argjson created "$created_prs" \
  --argjson merged "$merged_prs" \
  --argjson reviewed "$reviewed_prs" \
  --argjson issues "$involved_issues" \
  '{
    user: $user, org: $org, period: {start: $start, end: $end},
    counts: {
      prs_created: ($created | length),
      prs_merged: ($merged | length),
      prs_reviewed: ([$reviewed[] | select(.author.login != $user)] | length),
      issues_involved: ($issues | length)
    },
    prs_created: $created,
    prs_merged: $merged,
    prs_reviewed: [$reviewed[] | select(.author.login != $user)],
    issues_involved: $issues
  }'
