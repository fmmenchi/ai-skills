#!/usr/bin/env bash
# Symlink this workbench into every agent tool present on the machine.
# Idempotent, and it never overwrites a real file: whatever is in the way is
# reported and left where it is.
#
# One source, N paths. Agent Skills is an open standard (name + description in
# YAML frontmatter, a directory holding SKILL.md), so the same file is read
# unmodified by every tool below. What differs is only where each one looks.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS=(claude codex cursor gemini opencode)

present=""
absent=""
n_present=0
n_absent=0

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

# Plain strings, not arrays: macOS ships bash 3.2, where expanding an empty
# array under `set -u` is an error — and an empty skills/ is the normal state.
for tool in "${TOOLS[@]}"; do
  if [ -d "$HOME/.$tool" ]; then
    present="$present $tool"; n_present=$((n_present + 1))
  else
    absent="$absent $tool"; n_absent=$((n_absent + 1))
  fi
done

# The operating contract. Claude Code reads CLAUDE.md, everyone else AGENTS.md.
for tool in $present; do
  if [ "$tool" = claude ]; then
    link "$ROOT/AGENTS.md" "$HOME/.claude/CLAUDE.md"
  else
    link "$ROOT/AGENTS.md" "$HOME/.$tool/AGENTS.md"
  fi
done

# Skills, one by one, so vendor packs in the same directory survive.
shopt -s nullglob
n_skills=0
for skill in "$ROOT"/skills/*/; do
  name="$(basename "${skill%/}")"
  [ -f "${skill%/}/SKILL.md" ] || { echo "SKIP    $name (no SKILL.md; the name is case-sensitive)"; continue; }
  for tool in $present; do
    link "${skill%/}" "$HOME/.$tool/skills/$name"
  done
  n_skills=$((n_skills + 1))
done
shopt -u nullglob

# Silence is how an installer lies. Say what was not installed, and why.
echo
echo "tools linked: ${present:- none}"
if [ "$n_absent" -gt 0 ]; then
  echo "tools absent: $absent  (no ~/.<tool> directory — install the tool, then re-run)"
fi
if [ "$n_skills" -eq 0 ]; then
  echo "skills linked: none — skills/ is empty, which is the correct state until one earns its place"
else
  echo "skills linked: $n_skills x $n_present tool(s)"
fi
