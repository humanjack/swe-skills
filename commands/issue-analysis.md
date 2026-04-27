---
description: File the most recent repo analysis as an issue on the current repo
argument-hint: "[--repo owner/name] [--report <path>] [--yes]"
allowed-tools:
  - Bash(gh repo view:*)
  - Bash(gh issue create:*)
  - Bash(gh label list:*)
  - Bash(ls:*)
  - Bash(stat:*)
  - Bash(head:*)
  - Bash(wc:*)
  - Read
disable-model-invocation: false
---

Run the **Issue Workflow** defined in `skills/repo-analyzer/SKILL.md` with `$ARGUMENTS` as flags.

Recognized flags in `$ARGUMENTS`:
- `--repo owner/name` — override destination repo
- `--report <path>` — override report path (default: `.claude/cache/repo-analysis/latest.md`)
- `--yes` — skip the confirmation prompt
