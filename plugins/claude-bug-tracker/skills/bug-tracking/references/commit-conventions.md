# Commit Conventions for Bug Tracking

## Format

```
fix(scope): brief description of what was fixed

Optional body explaining root cause and approach.
```

## Scope Mapping

Scope is derived from the primary directory of changed files:

| Directory Pattern | Scope |
|-------------------|-------|
| `src/gui/` | `gui` |
| `src/core/` | `core` |
| `src/web/` | `web` |
| `src/api/` | `api` |
| `src/cli/` | `cli` |
| `tests/` | `tests` |
| `scripts/` | `scripts` |
| `config/` or root configs | `config` |

When multiple directories are touched, use the scope of the root-cause file.

## Examples

```
fix(gui): prevent stale async callbacks from corrupting browser panel

Added generation counter to discard results when user switches tabs
before previous load completes.
```

```
fix(core): use thread-local storage for httpx client in GraphClient

Each QThread worker now gets an isolated httpx.AsyncClient via
threading.local() instead of sharing one across threads.
```

## Why This Matters

The `fix(` prefix makes bug fix history searchable with:
```bash
git log --oneline --grep="^fix("
git log --oneline --grep="^fix(gui)"
```

The scan-commits.sh script uses this to detect fragile areas automatically.
