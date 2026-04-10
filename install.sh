#!/usr/bin/env bash
# install.sh — One-time global setup for agent-loom
#
# Run this once on any machine. Skills become available in Codex CLI,
# Ampcode, Claude Code, Warp, Gemini CLI, GitHub Copilot, and any other
# agentskills.io-compatible tool — no per-project setup needed.
#
# Usage:
#   bash install.sh          # symlink all skills globally
#   bash install.sh --copy   # copy instead of symlink (for remote/shared machines)
#   bash install.sh --update # pull latest from git and refresh links

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE="$REPO_DIR/.agents/skills"

# ── Target directories (all platforms read at least one of these) ──────────
TARGETS=(
  "$HOME/.agents/skills"          # Codex, Warp, Gemini, Replit, Bolt.new
  "$HOME/.claude/skills"          # Claude Code, Ampcode compatibility
)

MODE="symlink"
if [[ "$1" == "--copy" ]]; then MODE="copy"; fi
if [[ "$1" == "--update" ]]; then
  echo "→ Pulling latest skills..."
  git -C "$REPO_DIR" pull
  echo "→ Refreshing links..."
fi

echo ""
echo "agent-loom installer"
echo "==========================="
echo "Source : $SKILLS_SOURCE"
echo "Mode   : $MODE"
echo ""

install_skill() {
  local skill_dir="$1"
  local skill_name
  skill_name=$(basename "$skill_dir")

  for target_base in "${TARGETS[@]}"; do
    mkdir -p "$target_base"
    local dest="$target_base/$skill_name"

    # Remove stale link/dir if it exists
    if [[ -L "$dest" || -d "$dest" ]]; then
      rm -rf "$dest"
    fi

    if [[ "$MODE" == "copy" ]]; then
      cp -r "$skill_dir" "$dest"
      echo "  [copied]   $dest"
    else
      ln -s "$skill_dir" "$dest"
      echo "  [linked]   $dest → $skill_dir"
    fi
  done
}

# ── Install each skill ──────────────────────────────────────────────────────
skill_count=0
for skill in "$SKILLS_SOURCE"/*/; do
  [[ -f "$skill/SKILL.md" ]] || continue
  install_skill "$skill"
  ((skill_count++))
done

# ── Summary ─────────────────────────────────────────────────────────────────
echo ""
echo "✓ $skill_count skill(s) installed globally"
echo ""
echo "Works immediately in:"
echo "  • Codex CLI    — run 'codex' in any project, type /skills to verify"
echo "  • Ampcode      — skills auto-load on next session"
echo "  • Claude Code  — run 'claude' in any project"
echo "  • Warp         — type / in agent chat to see skill list"
echo "  • Gemini CLI   — skills auto-load on next session"
echo "  • GitHub Copilot CLI — skills auto-load on next session"
echo ""
echo "To update skills later:"
echo "  bash $REPO_DIR/install.sh --update"
echo ""
echo "To add skills to a specific project (for teammates):"
echo "  cp -r ~/.agents/skills/<skill-name> your-project/.agents/skills/"
