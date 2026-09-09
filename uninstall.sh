#!/usr/bin/env sh
set -eu

DESTINATION="${CODEX_SKILLS_DIR:-${HOME}/.agents/skills}"

if [ "${1:-}" = "--dest" ]; then
  DESTINATION="$2"
elif [ "$#" -gt 0 ]; then
  printf 'Usage: uninstall.sh [--dest PATH]\n' >&2
  exit 2
fi

SKILLS="
gpt-image25-social-design
gpt-image25-product-studio
gpt-image25-precise-edit
gpt-image25-sketch-render
gpt-image25-knowledge-visual
gpt-image25-brand-series
"

STAMP=$(date -u +%Y%m%dT%H%M%SZ)
BACKUP_ROOT="${HOME}/.agents/skill-backups/gpt-image-2-5-skills/uninstalled-$STAMP"
MOVED=0

for skill in $SKILLS; do
  target="$DESTINATION/$skill"
  if [ -e "$target" ]; then
    mkdir -p "$BACKUP_ROOT"
    mv "$target" "$BACKUP_ROOT/$skill"
    MOVED=1
  fi
done

if [ "$MOVED" -eq 1 ]; then
  printf 'Uninstalled the skill pack. Files were moved to %s\n' "$BACKUP_ROOT"
else
  printf 'No installed GPT Image 2.5 skills were found in %s\n' "$DESTINATION"
fi
