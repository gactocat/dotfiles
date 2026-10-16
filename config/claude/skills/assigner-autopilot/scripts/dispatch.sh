#!/bin/bash
# assigner autopilot dispatcher. Runs every 10 minutes from the Orca automation precheck or launchd.
# In an Orca precheck it always exits non-zero so that the automation never starts an agent of its own;
# the per-task sessions are the only agents.
#
#   dispatch.sh              detect, triage, launch and clean up
#   DRY_RUN=1 dispatch.sh    detect and triage without starting sessions or saving state
#   FORCE=1 dispatch.sh      run outside the configured work hours
DIR="$(cd "$(dirname "$0")" && pwd)"
export PATH="/Applications/Orca.app/Contents/Resources/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
args=(dispatch)
[ -n "${DRY_RUN:-}" ] && args+=(--dry-run)
[ -n "${FORCE:-}" ] && args+=(--force)
/usr/bin/python3 "$DIR/autopilot.py" "${args[@]}"
# Never let the Orca automation start its own agent.
exit 1
