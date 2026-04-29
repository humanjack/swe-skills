# swe-skills

A collection of [Claude Code](https://claude.ai/code) **skills** — reusable workflow definitions that extend Claude with new slash commands and natural-language triggers.

## What are skills?

A **skill** is a markdown file (`SKILL.md`) that defines a workflow for Claude Code. Once installed, a skill:

- Activates on **slash commands** (e.g. `/analyze-repo <url>`) or **natural-language phrases** (e.g. "analyze this github repo: …")
- Ships with its own tool permissions, helper files, and optional slash-command stubs under `commands/`
- Lives in `~/.claude/skills/<skill-name>/` so it's available in every project

Skills are the building block for automating multi-step developer workflows without writing a plugin or extension.

## Available skills

| Skill | Slash commands | What it does |
|---|---|---|
| [`repo-analyzer`](skills/repo-analyzer/SKILL.md) | `/analyze-repo`, `/issue-analysis` | Analyzes any public GitHub repo with Mermaid visualizations (features, architecture, code structure, workflows, security, applications) and files the report as a GitHub issue |

## Install

Clone this repo, then choose one of three modes.

### Option 1 — symlink (recommended for development)

```bash
git clone https://github.com/humanjack/swe-skills
cd swe-skills
./install.sh
```

Creates symlinks from `~/.claude/skills/repo-analyzer` and `~/.claude/commands/{analyze-repo,issue-analysis}.md` into this repo. Edits in the repo take effect immediately — no reinstall needed.

### Option 2 — copy

```bash
./install.sh --copy
```

Copies files into `~/.claude` instead of symlinking. Re-run after every edit.

### Option 3 — Claude Code plugin

```bash
# In a Claude Code session:
/plugin marketplace add humanjack/swe-skills
/plugin install repo-analyzer@swe-skills
```

Installs directly from the marketplace. No local clone required.

### Uninstall

```bash
./install.sh --uninstall
```

After installing, **start a new Claude Code session** (or restart the app) to pick up the skill.

## Use

### `/analyze-repo` — analyze a GitHub repository

```bash
/analyze-repo https://github.com/psf/requests
```

Produces a markdown report with Mermaid diagrams across six dimensions:

- **Features** — mind map of capabilities
- **Architecture & design** — C4-style container/component flowchart
- **Code structure** — directory graph + language breakdown pie chart
- **Key workflows** — up to three sequence diagrams
- **Security issues** — CVE/finding table + risk quadrant
- **Possible applications** — persona × use-case table

Natural-language trigger: `analyze this github repo: <url>`

### `/issue-analysis` — file the report as a GitHub issue

```bash
# File on the current repo (default)
/issue-analysis

# Override destination or report
/issue-analysis --repo someone/some-repo
/issue-analysis --report .claude/cache/repo-analysis/<file>.md
/issue-analysis --yes    # skip confirmation prompt
```

Natural-language trigger: `create issue about analysis result`, `file analysis as issue`

### Cache

Reports are saved to `.claude/cache/repo-analysis/` (gitignored). The latest report is also written to `latest.md` so `/issue-analysis` can find it without arguments. The last 20 timestamped reports are kept.

## Requirements

- `gh` (GitHub CLI) — authenticated via `gh auth login`
- `git` ≥ 2.32 recommended (partial clone support); older versions fall back to a shallow clone automatically
- Optional: `npm`, `pip-audit` — used for richer dependency-vulnerability scans; degrades gracefully to Dependabot via `gh api` if missing

## Layout

```text
swe-skills/
├── .claude-plugin/
│   └── plugin.json                    # plugin manifest
├── skills/
│   └── repo-analyzer/
│       ├── SKILL.md                   # workflow definition (source of truth)
│       ├── ANALYSIS_TEMPLATE.md       # report markdown skeleton
│       └── lib/
│           ├── secrets-patterns.txt   # regexes for secret scanning
│           └── deps-detect.md         # manifest → audit command lookup
├── commands/
│   ├── analyze-repo.md                # /analyze-repo slash command stub
│   └── issue-analysis.md             # /issue-analysis slash command stub
├── install.sh
└── README.md
```
