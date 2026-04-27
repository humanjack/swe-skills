# Dependency manifest → audit command

Quick lookup for the security pass. Each command runs *inside* the cloned repo (`$WORK`) and is wrapped in `timeout 60` so a hang doesn't kill the run. Output is JSON where possible.

| Manifest present | Stack | Audit command | Notes |
|---|---|---|---|
| `package-lock.json` | Node | `npm audit --json` | Needs `npm` on PATH; works only with a lockfile. Skip `pnpm-lock.yaml` / `yarn.lock` for v1 (different commands; degrade to Dependabot). |
| `requirements.txt` | Python | `pip-audit -r requirements.txt --format json` | Needs `pip-audit` (`pip install pip-audit`). |
| `pyproject.toml` (with lock or pinned deps) | Python | `pip-audit --format json` | If `pip-audit` finds the project, it audits transitively. |
| `Cargo.lock` | Rust | `cargo audit --json` | Needs `cargo-audit`. Skip if not installed → Dependabot fallback. |
| `go.sum` | Go | `govulncheck ./...` | Needs `govulncheck`. |
| `Gemfile.lock` | Ruby | `bundle audit check --update` | Needs `bundler-audit`. |
| `composer.lock` | PHP | `composer audit --format=json` | Composer 2.4+. |
| any | any | `gh api repos/<owner>/<repo>/dependabot/alerts --paginate` | **Always available** if Dependabot is enabled on the repo. Use as primary fallback. |

## Decision tree

1. If a stack-specific tool is on PATH AND its lockfile is present → run it, capture JSON.
2. Else → call `gh api repos/.../dependabot/alerts`. If 404 (Dependabot disabled) → emit "no dependency vulnerability data available" in the security section.
3. Always run the in-tree checks (secrets regex, GitHub Actions audit, license, Dockerfile) regardless of dep tooling availability.

## Other in-tree checks (independent of stack)

- **Secrets**: `git grep -nIE -f lib/secrets-patterns.txt`
- **GitHub Actions**: parse `.github/workflows/*.yml` — flag `permissions: write-all`, `pull_request_target` + `${{ github.event.* }}` interpolations, `actions/checkout` against PR head ref
- **License**: from `gh repo view --json licenseInfo`
- **Dockerfile**: grep for `:latest`, `--privileged`, `ENV .*(SECRET|TOKEN|KEY|PASSWORD)=`
