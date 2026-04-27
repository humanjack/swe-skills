#!/usr/bin/env bash
set -euo pipefail

# install.sh — install/uninstall the repo-analyzer skill into ~/.claude
#
# Usage:
#   ./install.sh              # symlink (default; edits in repo take effect immediately)
#   ./install.sh --copy       # copy files instead
#   ./install.sh --plugin     # print Claude Code plugin install instructions
#   ./install.sh --uninstall  # remove symlinks/copies
#   ./install.sh --help

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
SKILL_NAME="repo-analyzer"

SKILL_SRC="$REPO_ROOT/skills/$SKILL_NAME"
SKILL_DEST="$CLAUDE_DIR/skills/$SKILL_NAME"

CMD_FILES=(analyze-repo.md issue-analysis.md)

mode="symlink"
case "${1:-}" in
  ""|"--symlink") mode="symlink" ;;
  "--copy")       mode="copy" ;;
  "--plugin")     mode="plugin" ;;
  "--uninstall")  mode="uninstall" ;;
  "--help"|"-h")
    sed -n '3,12p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
    ;;
  *)
    echo "unknown flag: $1 (use --help)" >&2
    exit 2
    ;;
esac

ensure_dirs() {
  mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/commands"
}

remove_existing() {
  # symlink, real dir, or copied file — wipe before reinstalling
  if [[ -e "$SKILL_DEST" || -L "$SKILL_DEST" ]]; then
    rm -rf "$SKILL_DEST"
  fi
  for f in "${CMD_FILES[@]}"; do
    local d="$CLAUDE_DIR/commands/$f"
    if [[ -e "$d" || -L "$d" ]]; then
      rm -f "$d"
    fi
  done
}

case "$mode" in
  symlink)
    ensure_dirs
    remove_existing
    ln -s "$SKILL_SRC" "$SKILL_DEST"
    for f in "${CMD_FILES[@]}"; do
      ln -s "$REPO_ROOT/commands/$f" "$CLAUDE_DIR/commands/$f"
    done
    echo "Installed (symlink):"
    echo "  $SKILL_DEST -> $SKILL_SRC"
    for f in "${CMD_FILES[@]}"; do
      echo "  $CLAUDE_DIR/commands/$f -> $REPO_ROOT/commands/$f"
    done
    echo "Restart Claude Code or start a new session to pick up the skill."
    ;;

  copy)
    ensure_dirs
    remove_existing
    cp -R "$SKILL_SRC" "$SKILL_DEST"
    for f in "${CMD_FILES[@]}"; do
      cp "$REPO_ROOT/commands/$f" "$CLAUDE_DIR/commands/$f"
    done
    echo "Installed (copy):"
    echo "  $SKILL_DEST"
    for f in "${CMD_FILES[@]}"; do
      echo "  $CLAUDE_DIR/commands/$f"
    done
    echo "NOTE: re-run ./install.sh --copy after edits."
    ;;

  plugin)
    cat <<'EOF'
To install as a Claude Code plugin (shareable across users):

  1. In Claude Code, run:
       /plugin marketplace add humanjack/swe-skills

  2. Then install the plugin from the marketplace:
       /plugin install repo-analyzer@swe-skills

The repo's .claude-plugin/plugin.json declares the manifest. Marketplace
registration may require a marketplace.json — see Claude Code's plugin docs
for the latest format.
EOF
    ;;

  uninstall)
    remove_existing
    echo "Uninstalled $SKILL_NAME from $CLAUDE_DIR."
    ;;
esac
