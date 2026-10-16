#!/usr/bin/env python3
"""PreToolUse hook for the unattended first-pass investigation (claude -p) of assigner autopilot.

It is passed only to those sessions through --settings, so other sessions are unaffected.
Exit 2 blocks the tool call and feeds stderr back to the model.

Blocks:
  - MCP tools whose name is not read-like (send, create, update, delete, react, draft, ...)
  - Slack posting from the shell (scripts/slack post, chat.postMessage, ...)
  - git push, GitHub writes through gh
  - mutating aws / gcloud / kubectl / terraform commands, PERMAN mutations, orca, esa writes
"""
import json
import re
import shlex
import sys

READ_VERBS = re.compile(
    r"(^|[_-])(read|get|list|search|fetch|query|view|find|describe|lookup|whoami|metadata|context|screenshot|download|export)([_-]|$)"
)

AWS_MUTATING = re.compile(
    r"^(put|delete|create|update|start|stop|send|purge|redrive|invoke|terminate|modify|attach|detach|tag|untag|"
    r"restore|enable|disable|set|reset|register|deregister|batch-write|batch-delete|transact-write|receive-message|"
    r"publish|associate|disassociate|import|run|execute|cancel|abort|complete|upload|rotate|replace|reboot|"
    r"revoke|authorize|change|copy|add|remove|apply|admin-|confirm|respond|signal|increase|decrease|merge|"
    r"promote|resume|pause|retry|test-invoke)"
)

SHELL_DENY = [
    (re.compile(r"scripts/slack\S*\s+(\S+\s+)*post\b"), "Slack への投稿"),
    (re.compile(r"chat\.(postMessage|update|delete|scheduleMessage)|reactions\.add"), "Slack への書き込み"),
    (re.compile(r"\bgit\s+push\b"), "git push"),
    (re.compile(r"\bgh\s+(pr|issue)\s+(create|comment|edit|close|reopen|merge|review|lock|delete|transfer|develop)\b"), "GitHub への書き込み"),
    (re.compile(r"\bgh\s+(release|label|repo|secret|variable|workflow)\s+(create|edit|delete|set|run|enable|disable|upload|rename|archive|fork|sync)\b"), "GitHub への書き込み"),
    (re.compile(r"\bgh\s+api\b.*(-X|--method)\s*['\"]?(POST|PATCH|PUT|DELETE)", re.I), "GitHub API への書き込み"),
    (re.compile(r"\bkubectl\s+(apply|create|delete|edit|patch|replace|scale|rollout|label|annotate|cordon|drain|taint|set|exec|cp)\b"), "Kubernetes の変更"),
    (re.compile(r"\bterraform\s+(apply|destroy|import|state|taint|untaint)\b"), "Terraform の変更"),
    (re.compile(r"\bgcloud\b.*\s(create|delete|update|deploy|set|add-iam-policy-binding|remove-iam-policy-binding|patch|import|enable|disable)\b"), "GCP の変更"),
    (re.compile(r"\borca\s+"), "Orca の操作"),
    (re.compile(r"\besa\s+(post|comment)\s+(create|update|append|prepend|delete|archive|duplicate|rollback)\b"), "esa への書き込み"),
    (re.compile(r"perman", re.I), None),  # checked below together with "mutation"
]


def deny(reason):
    sys.stderr.write(
        "assigner autopilot の一次調査では「%s」はできません。必要なら、報告書に文案や手順として書いてください。\n" % reason
    )
    sys.exit(2)


def check_aws(command):
    # Inspect each aws invocation in the command line: aws [global options] <service> <operation>
    for segment in re.split(r"&&|\|\||;|\|", command):
        try:
            words = shlex.split(segment)
        except ValueError:
            words = segment.split()
        if "aws" not in words:
            continue
        rest = words[words.index("aws") + 1:]
        positional = []
        skip = False
        for w in rest:
            if skip:
                skip = False
                continue
            if w.startswith("--"):
                if "=" not in w and w not in ("--no-cli-pager", "--debug", "--no-paginate", "--no-sign-request"):
                    skip = True
                continue
            positional.append(w)
        if len(positional) < 2:
            continue
        service, operation = positional[0], positional[1]
        if service == "s3":
            if operation in ("rm", "mv", "sync", "mb", "rb"):
                deny("aws s3 %s" % operation)
            if operation == "cp" and len(positional) >= 4 and positional[3].startswith("s3://"):
                deny("S3 への書き込み")
            continue
        if service == "s3api" and operation in ("get-object", "head-object", "list-objects-v2", "list-objects", "list-object-versions"):
            continue
        if service == "sts":
            continue
        if service == "logs" and operation in ("start-query", "stop-query"):
            continue  # Logs Insights queries are read-only
        if AWS_MUTATING.match(operation):
            deny("aws %s %s" % (service, operation))


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        sys.exit(0)
    tool = data.get("tool_name") or ""
    tool_input = data.get("tool_input") or {}

    if tool.startswith("mcp__"):
        name = tool.split("__")[-1]
        if not READ_VERBS.search(name):
            deny(tool)
        sys.exit(0)

    if tool in ("Artifact", "ArtifactData", "Workflow", "CronCreate", "CronDelete", "RemoteTrigger", "ScheduleWakeup", "SendMessage"):
        deny(tool)

    if tool == "Bash":
        command = tool_input.get("command") or ""
        for pattern, reason in SHELL_DENY:
            if reason is None:
                if pattern.search(command) and re.search(r"\bmutation\b", command):
                    deny("PERMAN の mutation")
                continue
            if pattern.search(command):
                deny(reason)
        if re.search(r"\bgh\s+api\b", command) and re.search(r"\s(-f|-F|--field|--raw-field|--input)(\s|=)", command) \
                and not re.search(r"(-X|--method)[\s=]*['\"]?GET\b", command, re.I):
            deny("GitHub API への書き込み (-f や --input は POST になる)")
        check_aws(command)
    sys.exit(0)


if __name__ == "__main__":
    main()
