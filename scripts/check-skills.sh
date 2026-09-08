#!/usr/bin/env bash
# Check every skill against the Agent Skills open standard, plus the portability
# rule this repository adds on top.
#
# Fail-closed on structure: a malformed skill is silently ignored by the tools,
# which is the worst failure mode there is. Warn-only on style: a linter that
# cries wolf gets switched off.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
errors=0
warnings=0

err()  { echo "ERROR  $1"; errors=$((errors + 1)); }
warn() { echo "warn   $1"; warnings=$((warnings + 1)); }

shopt -s nullglob
dirs=("$ROOT"/skills/*/)

if [ ${#dirs[@]} -eq 0 ]; then
  echo "skills/ is empty — nothing to check, and that is a valid state."
  exit 0
fi

for dir in "${dirs[@]}"; do
  name="$(basename "${dir%/}")"
  file="${dir%/}/SKILL.md"

  # The filename is case-sensitive to the tools, but macOS APFS is not: a plain
  # [ -f SKILL.md ] test happily matches a SKILL.MD that Codex will never load.
  # find matches against the real directory entry, so it sees the true casing.
  if [ -z "$(find "${dir%/}" -maxdepth 1 -name 'SKILL.md')" ]; then
    other="$(find "${dir%/}" -maxdepth 1 -iname 'skill.md' | head -1)"
    if [ -n "$other" ]; then
      err "$name: entry file is $(basename "$other"), must be exactly SKILL.md (case-sensitive)"
    else
      err "$name: no SKILL.md"
    fi
    continue
  fi

  # Frontmatter must open the file: no blank line, no title above it.
  if [ "$(head -1 "$file")" != "---" ]; then
    err "$name: YAML frontmatter must be the first line of the file"
    continue
  fi

  front="$(awk 'NR>1 && /^---[[:space:]]*$/{exit} NR>1' "$file")"
  fname="$(printf '%s\n' "$front" | sed -n 's/^name:[[:space:]]*//p' | head -1 | tr -d '"'"'"'')"
  fdesc="$(printf '%s\n' "$front" | sed -n 's/^description:[[:space:]]*//p' | head -1)"

  [ -n "$fname" ] || err "$name: frontmatter has no 'name'"
  [ -n "$fdesc" ] || err "$name: frontmatter has no 'description' — the only field loaded at startup"

  if [ -n "$fname" ] && [ "$fname" != "$name" ]; then
    err "$name: frontmatter name '$fname' does not match the directory name"
  fi

  if [ -n "$fdesc" ]; then
    len=${#fdesc}
    [ "$len" -gt 1024 ] && err "$name: description is $len chars, over the 1024 limit"
    [ "$len" -lt 40 ] && warn "$name: description is $len chars — too thin to route on"
    # The description is the routing contract: it must say when, not only what.
    printf '%s' "$fdesc" | grep -qiE 'use (when|for|it when)|should be used|when the user|triggers?:' \
      || warn "$name: description states what the skill does but not when to use it"
  fi

  # Progressive disclosure: a long body is paid for on every activation.
  lines=$(wc -l < "$file")
  [ "$lines" -gt 500 ] && warn "$name: SKILL.md is $lines lines — move detail into references/"

  # Portability. This repository holds tool-agnostic skills only: naming a
  # vendor's tool makes the skill unusable everywhere that tool does not exist.
  hits="$(grep -nE '\b(Task tool|TodoWrite|isolation:[[:space:]]*worktree|WebFetch tool|mcp__)' "$file" | head -3)"
  if [ -n "$hits" ]; then
    while IFS= read -r h; do warn "$name: names a vendor tool — $h"; done <<< "$hits"
  fi

  # A reference nobody can open is worse than no reference at all. A skill is
  # symlinked into each tool's own directory, so only paths that resolve inside
  # the skill survive the trip: one that resolves at the repository root works
  # while the repository is the working directory and breaks everywhere else.
  while IFS= read -r ref; do
    if [ -e "${dir%/}/$ref" ]; then
      continue
    elif [ -e "$ROOT/$ref" ]; then
      warn "$name: '$ref' resolves at the repository root, not inside the skill — it will not resolve once symlinked"
    else
      err "$name: references '$ref', which does not exist"
    fi
  done < <(grep -oE '(references|scripts|assets)/[A-Za-z0-9._/-]+' "$file" | sort -u)

  # Evals live outside the skill, in evals/<name>/ (ADR 0006), because the skill
  # directory ships whole. Three scenarios are the bar; this counts files, which
  # is a floor — whether they are runnable is the review's job. The config beside
  # them is what executes, on promptfoo (ADR 0007).
  n_evals=$(find "$ROOT/evals/$name" -maxdepth 1 -name '[0-9][0-9]-*.md' 2>/dev/null | wc -l | tr -d ' ')
  [ "$n_evals" -lt 3 ] && warn "$name: $n_evals eval scenario(s) in evals/$name — three are the bar (ADR 0006)"
  [ -f "$ROOT/evals/$name/promptfooconfig.yaml" ] \
    || warn "$name: no evals/$name/promptfooconfig.yaml — the scenarios are documented but nothing runs them (ADR 0007)"
done
shopt -u nullglob

echo
echo "${#dirs[@]} skill(s) checked — $errors error(s), $warnings warning(s)"
[ "$errors" -eq 0 ]
