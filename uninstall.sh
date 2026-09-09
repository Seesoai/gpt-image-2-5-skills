#!/usr/bin/env sh
set -eu

DESTINATION="${CODEX_SKILLS_DIR:-${HOME}/.agents/skills}"
ALL_SKILLS="
gpt-image25-social-design
gpt-image25-product-studio
gpt-image25-precise-edit
gpt-image25-sketch-render
gpt-image25-knowledge-visual
gpt-image25-brand-series
"
SELECTED_SKILLS=""

is_known_skill() {
  for known_skill in $ALL_SKILLS; do
    [ "$known_skill" = "$1" ] && return 0
  done
  return 1
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --skill)
      [ "$#" -ge 2 ] || { printf '%s\n' '--skill requires a name.' >&2; exit 2; }
      is_known_skill "$2" || { printf 'Unknown skill: %s\n' "$2" >&2; exit 2; }
      SELECTED_SKILLS="$SELECTED_SKILLS $2"
      shift 2
      ;;
    --dest) DESTINATION="$2"; shift 2 ;;
    --list) printf '%s\n' $ALL_SKILLS; exit 0 ;;
    -h|--help)
      printf 'Usage: uninstall.sh [--skill NAME]... [--dest PATH]\n'
      exit 0
      ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; exit 2 ;;
  esac
done

if [ -n "$SELECTED_SKILLS" ]; then
  SKILLS="$SELECTED_SKILLS"
else
  SKILLS="$ALL_SKILLS"
fi

STAMP=$(date -u +%Y%m%dT%H%M%SZ)
BACKUP_ROOT="${HOME}/.agents/skill-backups/gpt-image-2-5-skills/uninstalled-$STAMP"
MOVED=0
MOVED_COUNT=0

for skill in $SKILLS; do
  target="$DESTINATION/$skill"
  if [ -e "$target" ]; then
    mkdir -p "$BACKUP_ROOT"
    mv "$target" "$BACKUP_ROOT/$skill"
    MOVED=1
    MOVED_COUNT=$((MOVED_COUNT + 1))
  fi
done

if [ "$MOVED" -eq 1 ]; then
  printf 'Uninstalled %s skill(s). Files were moved to %s\n' "$MOVED_COUNT" "$BACKUP_ROOT"
else
  printf 'No installed GPT Image 2.5 skills were found in %s\n' "$DESTINATION"
fi
