#!/usr/bin/env sh
set -eu

DEFAULT_REPOSITORY="Seesoai/gpt-image-2-5-skills"
REPOSITORY="$DEFAULT_REPOSITORY"
REF="main"
SOURCE_DIR=""
DESTINATION="${CODEX_SKILLS_DIR:-${HOME}/.agents/skills}"

usage() {
  cat <<'EOF'
Install one or all GPT Image 2.5 Chinese skills for Codex.

Usage:
  install.sh [--skill NAME]... [--repo OWNER/REPO] [--ref REF] [--dest PATH]
  install.sh --source PATH [--skill NAME]... [--dest PATH]
  install.sh --list

Without --skill, all six skills are installed. Repeat --skill to install
multiple selected skills.

Environment:
  CODEX_SKILLS_DIR  Override the default destination (~/.agents/skills).
EOF
}

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

add_skill() {
  is_known_skill "$1" || {
    printf 'Unknown skill: %s\nRun with --list to see valid names.\n' "$1" >&2
    exit 2
  }
  for selected_skill in $SELECTED_SKILLS; do
    [ "$selected_skill" = "$1" ] && return 0
  done
  SELECTED_SKILLS="$SELECTED_SKILLS $1"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --skill) [ "$#" -ge 2 ] || { printf '%s\n' '--skill requires a name.' >&2; exit 2; }; add_skill "$2"; shift 2 ;;
    --list) printf '%s\n' $ALL_SKILLS; exit 0 ;;
    --repo) REPOSITORY="$2"; shift 2 ;;
    --ref) REF="$2"; shift 2 ;;
    --source) SOURCE_DIR="$2"; shift 2 ;;
    --dest) DESTINATION="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
done

if [ -n "$SELECTED_SKILLS" ]; then
  SKILLS="$SELECTED_SKILLS"
else
  SKILLS="$ALL_SKILLS"
fi

TEMP_BASE="${TMPDIR:-${TMP:-${TEMP:-/tmp}}}"
mkdir -p "$TEMP_BASE"
TEMP_DIR=$(mktemp -d "$TEMP_BASE/gpt-image-2-5-skills.XXXXXX")
cleanup() { rm -rf "$TEMP_DIR"; }
trap cleanup EXIT INT TERM

if [ -n "$SOURCE_DIR" ]; then
  REPO_ROOT=$(cd "$SOURCE_DIR" && pwd)
else
  if [ -z "$REPOSITORY" ]; then
    printf 'Repository is not configured. Pass --repo OWNER/REPO.\n' >&2
    exit 2
  fi
  command -v curl >/dev/null 2>&1 || { printf 'curl is required.\n' >&2; exit 1; }
  command -v tar >/dev/null 2>&1 || { printf 'tar is required.\n' >&2; exit 1; }
  ARCHIVE="$TEMP_DIR/repository.tar.gz"
  curl -fsSL "https://codeload.github.com/${REPOSITORY}/tar.gz/${REF}" -o "$ARCHIVE"
  mkdir -p "$TEMP_DIR/repository"
  tar -xzf "$ARCHIVE" -C "$TEMP_DIR/repository" --strip-components=1
  REPO_ROOT="$TEMP_DIR/repository"
fi

SOURCE_SKILLS="$REPO_ROOT/plugins/gpt-image-2-5-skills/skills"
STAGE="$TEMP_DIR/stage"
mkdir -p "$STAGE"

for skill in $SKILLS; do
  if [ ! -f "$SOURCE_SKILLS/$skill/SKILL.md" ]; then
    printf 'Invalid package: missing %s/SKILL.md\n' "$skill" >&2
    exit 1
  fi
  cp -R "$SOURCE_SKILLS/$skill" "$STAGE/$skill"
done

mkdir -p "$DESTINATION"
STAMP=$(date -u +%Y%m%dT%H%M%SZ)
BACKUP_ROOT="${HOME}/.agents/skill-backups/gpt-image-2-5-skills/$STAMP"
BACKED_UP=0
INSTALLED_COUNT=0

for skill in $SKILLS; do
  target="$DESTINATION/$skill"
  if [ -e "$target" ]; then
    mkdir -p "$BACKUP_ROOT"
    mv "$target" "$BACKUP_ROOT/$skill"
    BACKED_UP=1
  fi
  mv "$STAGE/$skill" "$target"
  INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
done

printf 'Installed %s skill(s) to %s\n' "$INSTALLED_COUNT" "$DESTINATION"
if [ "$BACKED_UP" -eq 1 ]; then
  printf 'Previous versions were moved to %s\n' "$BACKUP_ROOT"
fi
printf 'Restart Codex, then invoke a skill with $gpt-image25-... or /skills.\n'
