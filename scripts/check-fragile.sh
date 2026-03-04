#!/usr/bin/env bash
# check-fragile.sh - Check if files (from stdin) are in fragile areas
#
# Reads file paths from stdin (one per line)
# Checks each against git fix() history
# Outputs warnings for files with prior fix history
#
# Usage: echo "src/gui/browser.py" | bash check-fragile.sh

set -euo pipefail

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    exit 0
fi

while IFS= read -r filepath; do
    [ -z "$filepath" ] && continue

    # Count fix() commits that touched this file
    fix_count=$(git log --oneline --all --grep="^fix(" -- "$filepath" 2>/dev/null | wc -l | tr -d ' ')

    if [ "$fix_count" -ge 3 ]; then
        echo "WARNING: ${filepath} is fragile (${fix_count} prior fix commits). Consider adding a regression test."
    elif [ "$fix_count" -ge 1 ]; then
        echo "NOTE: ${filepath} has ${fix_count} prior fix commit(s)."
    fi
done
