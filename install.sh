#!/usr/bin/env bash
# Symlink this workbench into every agent tool present on the machine.
# Idempotent, and it never overwrites a real file: whatever is in the way is
# reported and left where it is.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS=(claude codex cursor gemini opencode)

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest")" = "$src" ]; then echo "ok      $dest"; else
      ln -sfn "$src" "$dest"; echo "relink  $dest"; fi
    return 0
  fi
  if [ -e "$dest" ]; then
    echo "SKIP    $dest (exists and is not a symlink; move it aside to link it)"
    return 0
  fi
  ln -s "$src" "$dest"
  echo "link    $dest"
}

# The operating contract. Claude Code reads CLAUDE.md, everyone else AGENTS.md.
for tool in "${TOOLS[@]}"; do
  [ -d "$HOME/.$tool" ] || continue
  if [ "$tool" = claude ]; then
    link "$ROOT/AGENTS.md" "$HOME/.claude/CLAUDE.md"
  else
    link "$ROOT/AGENTS.md" "$HOME/.$tool/AGENTS.md"
  fi
done

# Skills, one by one, so vendor packs in the same directory survive.
shopt -s nullglob
for skill in "$ROOT"/skills/*/; do
  name="$(basename "${skill%/}")"
  for tool in "${TOOLS[@]}"; do
    [ -d "$HOME/.$tool" ] || continue
    link "${skill%/}" "$HOME/.$tool/skills/$name"
  done
done
shopt -u nullglob
