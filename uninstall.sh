#!/usr/bin/env bash
# uninstall.sh — Remove agent-loom from global skill directories
#
# Only removes symlinks that point into this repo. User-owned skills
# (real directories or symlinks pointing elsewhere) are never touched.
#
# Usage:
#   bash uninstall.sh            # remove all repo-managed symlinks
#   bash uninstall.sh --dry-run  # show what would be removed without removing

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE="$REPO_DIR/.agents/skills"

# ── Target directories (must match install.sh) ────────────────────────────
TARGETS=(
  "$HOME/.agents/skills"          # Codex, Warp, Gemini, Replit, Bolt.new
  "$HOME/.claude/skills"          # Claude Code, Ampcode compatibility
)

DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then DRY_RUN=true; fi

echo ""
echo "agent-loom uninstaller"
echo "============================="
echo "Source : $SKILLS_SOURCE"
if $DRY_RUN; then echo "Mode   : dry-run (no changes will be made)"; fi
echo ""

# ── Remove repo-managed symlinks ──────────────────────────────────────────
removed_count=0
skipped_count=0

for target_base in "${TARGETS[@]}"; do
  if [[ ! -d "$target_base" ]]; then
    echo "  [skip]     $target_base (does not exist)"
    continue
  fi

  echo "  Scanning   $target_base"

  for entry in "$target_base"/*/; do
    [[ -e "$entry" ]] || continue
    entry="${entry%/}"
    name=$(basename "$entry")

    if [[ -L "$entry" ]]; then
      link_target=$(readlink "$entry")
      # Resolve relative symlinks
      if [[ "$link_target" != /* ]]; then
        link_target="$(cd "$(dirname "$entry")" && cd "$(dirname "$link_target")" && pwd)/$(basename "$link_target")"
      fi

      case "$link_target" in
        "$SKILLS_SOURCE"/*)
          if $DRY_RUN; then
            echo "  [would rm] $entry → $link_target"
          else
            rm "$entry"
            echo "  [removed]  $entry → $link_target"
          fi
          removed_count=$((removed_count + 1))
          ;;
        *)
          echo "  [skip]     $entry → $link_target (points elsewhere)"
          skipped_count=$((skipped_count + 1))
          ;;
      esac
    else
      echo "  [skip]     $entry (real directory, not a symlink)"
      skipped_count=$((skipped_count + 1))
    fi
  done

  # Remove target directory if empty (but not its parent)
  if ! $DRY_RUN && [[ -d "$target_base" ]] && [ -z "$(ls -A "$target_base")" ]; then
    rmdir "$target_base"
    echo "  [cleaned]  $target_base (was empty)"
  fi
done

# ── Summary ─────────────────────────────────────────────────────────────────
echo ""
if $DRY_RUN; then
  echo "⊘ Dry run: $removed_count skill(s) would be removed, $skipped_count skipped"
else
  echo "✓ $removed_count skill(s) removed, $skipped_count skipped"
fi
echo ""
