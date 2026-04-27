---
description: Analyze a GitHub repo and emit a visual markdown report
argument-hint: <github-url>
allowed-tools:
  - Bash(gh repo view:*)
  - Bash(gh repo clone:*)
  - Bash(gh api:*)
  - Bash(gh release list:*)
  - Bash(git log:*)
  - Bash(git ls-files:*)
  - Bash(git rev-parse:*)
  - Bash(git grep:*)
  - Bash(git checkout:*)
  - Bash(find:*)
  - Bash(grep:*)
  - Bash(rg:*)
  - Bash(wc:*)
  - Bash(ls:*)
  - Bash(date:*)
  - Bash(npm audit:*)
  - Bash(pip-audit:*)
  - Bash(timeout:*)
  - Bash(mkdir:*)
  - Read
  - Write
  - Glob
disable-model-invocation: false
---

Run the **Analysis Workflow** defined in `skills/repo-analyzer/SKILL.md` with `$ARGUMENTS` as the GitHub URL.

If `$ARGUMENTS` is empty, ask the user for a GitHub URL.
