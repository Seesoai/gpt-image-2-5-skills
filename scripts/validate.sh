#!/usr/bin/env sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLUGIN="$ROOT/plugins/gpt-image-2-5-skills"
PLUGIN_VALIDATOR="${PLUGIN_VALIDATOR:-/root/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py}"
SKILL_VALIDATOR="${SKILL_VALIDATOR:-/root/.codex/skills/.system/skill-creator/scripts/quick_validate.py}"

python3 "$ROOT/scripts/validate.py"

if [ -f "$PLUGIN_VALIDATOR" ]; then
  python3 "$PLUGIN_VALIDATOR" "$PLUGIN"
fi

if [ -f "$SKILL_VALIDATOR" ]; then
  for skill in "$PLUGIN"/skills/*; do
    [ -d "$skill" ] || continue
    python3 "$SKILL_VALIDATOR" "$skill"
  done
fi

python3 -m json.tool "$ROOT/.agents/plugins/marketplace.json" >/dev/null
python3 -m json.tool "$PLUGIN/.codex-plugin/plugin.json" >/dev/null
sh -n "$ROOT/install.sh"
sh -n "$ROOT/uninstall.sh"

printf 'Repository validation passed.\n'
