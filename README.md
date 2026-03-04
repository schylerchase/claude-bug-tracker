# claude-bug-tracker

A Claude Code plugin that tracks bug fix regressions across projects. Identifies fragile code areas from git history, enforces `fix(scope):` commit conventions, and maintains a `bugs.md` knowledge file per project.

## Features

- **`/bug-track`** slash command: scan, list, add, resolve bugs
- **SessionStart hook**: auto-scans git history and outputs fragile area summary
- **PreToolUse hook**: warns when committing fixes without `fix(scope):` format, flags fragile files
- **bug-reviewer agent**: reviews code changes against fix history
- **bug-tracking skill**: proactive reference for debugging recurring issues

## Install

```bash
# From GitHub
claude plugins add github:schylerchase/claude-bug-tracker

# Or local development
claude plugins add file:///path/to/claude-bug-tracker
```

## Usage

```
/bug-track scan      # Scan git history, update bugs.md
/bug-track list      # Show active bugs and fragile areas
/bug-track add <desc> # Log a new bug
/bug-track resolve <id> # Mark a bug as fixed
```

## Commit Convention

Use `fix(scope): description` for bug fixes:

```
fix(gui): prevent stale async callbacks in browser panel
fix(core): use thread-local storage for httpx client
```

The plugin auto-detects fix commits and warns if the convention isn't followed.

## How It Works

1. On session start, the plugin scans the last 100 git commits for `fix(` prefixed messages
2. Files touched by multiple fix commits are flagged as "fragile areas"
3. When committing, the plugin checks staged files against fragile areas
4. The `bugs.md` file persists this knowledge across sessions

## Structure

```
claude-bug-tracker/
  commands/bug-track.md         # /bug-track slash command
  skills/bug-tracking/SKILL.md  # Proactive reference skill
  agents/bug-reviewer.md        # Code review agent
  hooks/hooks.json              # SessionStart + PreToolUse
  hooks/run-hook.cmd            # Cross-platform wrapper
  hooks/session-start           # Session initialization
  hooks/pre-commit-check        # Commit convention enforcement
  scripts/scan-commits.sh       # Git history scanner
  scripts/check-fragile.sh      # Fragile area checker
```

## License

MIT
