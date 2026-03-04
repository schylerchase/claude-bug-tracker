#!/usr/bin/env bash
# scan-commits.sh - Scan git history for fix() commits and identify fragile areas
#
# Output: one line per fragile file, sorted by fix count descending
# Format: <count> <file_path>
#
# Usage: bash scan-commits.sh [--limit N] [--threshold N]
# Options:
#   --limit N      Number of commits to scan (default: 100)
#   --threshold N  Minimum fix count to be "fragile" (default: 2)

set -euo pipefail

LIMIT=100
THRESHOLD=2

while [[ $# -gt 0 ]]; do
    case $1 in
        --limit) LIMIT="$2"; shift 2 ;;
        --threshold) THRESHOLD="$2"; shift 2 ;;
        *) shift ;;
    esac
done

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Not a git repository" >&2
    exit 1
fi

# Find all fix() commits in the last N commits
# Matches: fix(scope): description
fix_commits=$(git log --oneline -"$LIMIT" --grep="^fix(" --format="%H" 2>/dev/null || echo "")

if [ -z "$fix_commits" ]; then
    exit 0
fi

# For each fix commit, get the files that were changed
# Then count occurrences per file
temp_file=$(mktemp)
trap "rm -f '$temp_file'" EXIT

while IFS= read -r commit_hash; do
    git diff-tree --no-commit-id --name-only -r "$commit_hash" 2>/dev/null >> "$temp_file"
done <<< "$fix_commits"

# Count and sort, filter by threshold
sort "$temp_file" | uniq -c | sort -rn | while read -r count filepath; do
    if [ "$count" -ge "$THRESHOLD" ]; then
        echo "${count} ${filepath}"
    fi
done
