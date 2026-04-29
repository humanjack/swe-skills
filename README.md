# swe-skills

Claude Code skill that analyzes any public GitHub repository with rich Mermaid visualizations across six dimensions, then files the analysis as an issue on your *current* repo.

## What it does

- **`/analyze-repo <github-url>`** — produces a markdown report with Mermaid diagrams covering:
  - Features (mind map)
  - Architecture & design (flowchart)
  - Code structure (directory graph + language pie chart)
  - Key workflows (sequence diagrams)
  - Security issues (severity table + risk quadrant)
  - Possible applications (persona × use-case table)
- **`/issue-analysis`** — files the latest report as a GitHub issue on the repo where you ran the command (not the repo you analyzed).

Natural-language triggers also work: `analyze this github repo: <url>` and `create issue about analysis result`.

## Install

You have three options.

### Option 1 — symlink (recommended for development)

```bash
./install.sh
```

Creates symlinks from `~/.claude/skills/repo-analyzer` and `~/.claude/commands/{analyze-repo,issue-analysis}.md` into this repo. Edits in the repo take effect immediately. New Claude Code sessions pick up the skill.

### Option 2 — copy

```bash
./install.sh --copy
```

Copies files instead of symlinking. Re-run after every edit.

### Option 3 — Claude Code plugin

Add this repo as a plugin source in Claude Code, then `/plugin install repo-analyzer@swe-skills`. See `./install.sh --plugin` for the exact command.

### Uninstall

```bash
./install.sh --uninstall
```

## Use

```bash
# 1. Analyze a public repo
/analyze-repo https://github.com/psf/requests

# 2. File the analysis as an issue on your current repo
/issue-analysis

# Optional flags
/issue-analysis --repo someone/some-repo          # override destination
/issue-analysis --report .claude/cache/repo-analysis/<file>.md   # override report
/issue-analysis --yes                             # skip confirmation
```

## Requirements

- `gh` (GitHub CLI), authenticated via `gh auth login`
- `git` ≥ 2.32 for partial clone (`--filter=blob:none`)
- Optional: `npm`, `pip-audit` for richer dependency-vulnerability scans (degrades gracefully to Dependabot via `gh api` if missing)

## Cache

Reports are cached at `.claude/cache/repo-analysis/` (gitignored). The most recent report is also copied to `latest.md` for the issue workflow to pick up. Last 20 reports are kept.

## Layout

```text
swe-skills/
├── .claude-plugin/plugin.json
├── skills/repo-analyzer/
│   ├── SKILL.md                       # workflow definition (single source of truth)
│   ├── ANALYSIS_TEMPLATE.md           # markdown skeleton
│   └── lib/
│       ├── secrets-patterns.txt
│       └── deps-detect.md
├── commands/
│   ├── analyze-repo.md
│   └── issue-analysis.md
├── install.sh
└── README.md
```
