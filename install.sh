#!/usr/bin/env bash
# Installs the squad into a project (default: current directory).
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/metajar/squad/main/install.sh | bash
#   ./install.sh /path/to/project
#   ./install.sh --global        # install agents to ~/.claude/agents for every project
set -euo pipefail

REPO_URL="${SQUAD_REPO:-https://github.com/metajar/squad.git}"
TARGET="${1:-.}"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --depth 1 --quiet "$REPO_URL" "$TMP/squad"

if [[ "$TARGET" == "--global" ]]; then
  AGENTS_DIR="$HOME/.claude/agents"
  ROSTER_DIR="$HOME/.claude"
else
  AGENTS_DIR="$TARGET/.claude/agents"
  ROSTER_DIR="$TARGET"
fi

mkdir -p "$AGENTS_DIR"

for f in "$TMP/squad/.claude/agents/"*.md; do
  name="$(basename "$f")"
  if [[ -e "$AGENTS_DIR/$name" ]]; then
    echo "skip   $AGENTS_DIR/$name (already exists)"
  else
    cp "$f" "$AGENTS_DIR/$name"
    echo "added  $AGENTS_DIR/$name"
  fi
done

if [[ -e "$ROSTER_DIR/SQUAD.md" ]]; then
  echo "skip   $ROSTER_DIR/SQUAD.md (already exists)"
else
  cp "$TMP/squad/SQUAD.md" "$ROSTER_DIR/SQUAD.md"
  echo "added  $ROSTER_DIR/SQUAD.md"
fi

echo
echo "Squad installed. Start a session led by the squad leader with:"
echo "  claude --agent squad-leader"
