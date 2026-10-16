#!/bin/bash
# Runs inside the task's terminal (Orca) or in the background (plain launcher):
# the unattended first-pass investigation with claude -p, then hands the conversation over with claude --resume.
DIR="$(cd "$(dirname "$0")" && pwd)"
export PATH="/Applications/Orca.app/Contents/Resources/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
exec /usr/bin/python3 "$DIR/autopilot.py" run-task "$1"
