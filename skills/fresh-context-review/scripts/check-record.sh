#!/usr/bin/env bash
# Check a review record against the reviews it accounts for.
#
#   scripts/check-record.sh <artefact> <reviews-dir>
#
# For every <date>-<artefact>-<lens>-r<N>.md in the directory: the file name
# matches the pattern, the record has a section headed by that file name, and
# the section's table has exactly one row per finding in the review, each with
# a disposition from the fixed set. Findings are the lines that open with a
# bold number: "**7. ...**". A brief (*.brief.md) is not a review and is skipped.
#
# Exit 1 on any mismatch. Prints what it counted, so a wrong count is visible
# rather than trusted — the point of the check is that nobody counts by hand.
set -uo pipefail

artefact="${1:?artefact name}"
dir="${2:?reviews directory}"
record="$dir/$artefact.record.md"
errors=0

err() { echo "error  $1"; errors=$((errors + 1)); }

[ -f "$record" ] || { echo "error  no record at $record"; exit 1; }

shopt -s nullglob
reviews=("$dir"/*-"$artefact"-*-r[0-9]*.md)
shopt -u nullglob
reviews=($(printf '%s\n' "${reviews[@]}" | grep -v '\.brief\.md$'))

[ ${#reviews[@]} -gt 0 ] || { echo "error  no reviews for $artefact in $dir"; exit 1; }

for review in "${reviews[@]}"; do
  file="$(basename "$review")"

  echo "$file" | grep -qE "^[0-9]{4}-[0-9]{2}-[0-9]{2}-$artefact-[a-z0-9-]+-r[0-9]+\.md$" \
    || err "$file: name is not <date>-$artefact-<lens>-r<N>.md"

  findings=$(grep -cE '^\*\*[0-9]+\.' "$review")

  # The record section runs from the heading naming this file to the next heading.
  section="$(awk -v h="$file" '
    /^## /{ inside = (index($0, h) > 0) ; next }
    inside { print }
  ' "$record")"
  [ -n "$section" ] || { err "$file: no section in the record"; continue; }

  rows=$(printf '%s\n' "$section" | grep -cE '^\|[[:space:]]*[0-9]+[[:space:]]*\|')
  bad=$(printf '%s\n' "$section" | grep -E '^\|[[:space:]]*[0-9]+[[:space:]]*\|' \
        | grep -vcE '^\|[[:space:]]*[0-9]+[[:space:]]*\|[[:space:]]*`?(accepted|reduced|rejected|settled)`?[[:space:]]*\|')

  echo "$file: $findings finding(s), $rows row(s) in the record"
  [ "$findings" -eq "$rows" ] || err "$file: $findings findings but $rows rows"
  [ "$bad" -eq 0 ] || err "$file: $bad row(s) with a disposition outside accepted|reduced|rejected|settled"
done

echo "${#reviews[@]} review(s) checked — $errors error(s)"
[ "$errors" -eq 0 ]
