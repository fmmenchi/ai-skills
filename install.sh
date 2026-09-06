#!/usr/bin/env bash
# Symlink this workbench into every agent tool present on the machine.
# Idempotent, and it never overwrites a real file: whatever is in the way is
# reported and left where it is.
#
# One source, N paths. Agent Skills is an open standard (name + description in
# YAML frontmatter, a directory holding SKILL.md), so the same file is read
# unmodified by every tool below. What differs is only where each one looks.
#
# Three destinations cover the field, verified against each vendor's own docs:
#
#   ~/.claude/skills   Claude Code. opencode and Cursor also read it.
#   ~/.codex/skills    Codex CLI. Cursor reads it too, for compatibility.
#   ~/.agents/skills   the neutral hub: Cursor, Gemini CLI and opencode all
#                      read it by name, so one link there serves three tools.
#
# Per-tool guessing was the earlier design and it was wrong: opencode does not
# look in ~/.opencode/skills at all, it looks in ~/.config/opencode/skills.
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

# Skill destinations. ~/.agents is always maintained: it is the neutral hub of
# the standard rather than one tool's directory, so it is worth one directory
# even before the tools that read it are installed.
SKILL_DIRS="$HOME/.agents/skills"
[ -d "$HOME/.claude" ] && SKILL_DIRS="$SKILL_DIRS $HOME/.claude/skills"
[ -d "$HOME/.codex" ]  && SKILL_DIRS="$SKILL_DIRS $HOME/.codex/skills"

# Skills, one by one, so vendor packs in the same directory survive.
shopt -s nullglob
n_skills=0
for skill in "$ROOT"/skills/*/; do
  name="$(basename "${skill%/}")"
  # find matches the real directory entry, so it sees the true casing even on
  # a case-insensitive filesystem, where [ -f SKILL.md ] would accept SKILL.MD.
  if [ -z "$(find "${skill%/}" -maxdepth 1 -name 'SKILL.md')" ]; then
    echo "SKIP    $name (no SKILL.md; the name is case-sensitive)"
    continue
  fi
  for d in $SKILL_DIRS; do
    link "${skill%/}" "$d/$name"
  done
  n_skills=$((n_skills + 1))
done
shopt -u nullglob

# Silence is how an installer lies. Say what was not installed, and why.
echo
echo "contract linked into:${present:- none}"
if [ "$n_absent" -gt 0 ]; then
  echo "contract skipped for:$absent  (no ~/.<tool> directory yet)"
fi
if [ "$n_skills" -eq 0 ]; then
  echo "skills linked: none — skills/ is empty, which is the correct state until one earns its place"
else
  echo "skills linked: $n_skills into:$(echo "$SKILL_DIRS" | sed "s|$HOME|~|g")"
  echo "               ~/.agents is read by Cursor, Gemini CLI and opencode,"
  echo "               so a skill reaches them whether or not they are installed yet"
fi
