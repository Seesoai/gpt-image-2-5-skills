#!/usr/bin/env python3
"""Dependency-free repository checks for local use and GitHub Actions."""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PLUGIN = ROOT / "plugins" / "gpt-image-2-5-skills"
EXPECTED = {
    "gpt-image25-social-design",
    "gpt-image25-product-studio",
    "gpt-image25-precise-edit",
    "gpt-image25-sketch-render",
    "gpt-image25-knowledge-visual",
    "gpt-image25-brand-series",
}


def frontmatter(text: str) -> dict[str, str]:
    match = re.match(r"^---\n(.*?)\n---\n", text, re.DOTALL)
    if not match:
        raise ValueError("missing YAML frontmatter")
    values: dict[str, str] = {}
    for line in match.group(1).splitlines():
        key, separator, value = line.partition(":")
        if separator:
            values[key.strip()] = value.strip().strip('"')
    return values


def main() -> None:
    manifest = json.loads((PLUGIN / ".codex-plugin" / "plugin.json").read_text())
    assert manifest["name"] == "gpt-image-2-5-skills"
    assert re.fullmatch(r"\d+\.\d+\.\d+", manifest["version"])

    marketplace = json.loads((ROOT / ".agents" / "plugins" / "marketplace.json").read_text())
    entries = marketplace["plugins"]
    assert len(entries) == 1
    assert entries[0]["source"]["path"] == "./plugins/gpt-image-2-5-skills"

    skill_root = PLUGIN / "skills"
    actual = {path.name for path in skill_root.iterdir() if path.is_dir()}
    assert actual == EXPECTED, f"unexpected skill set: {sorted(actual ^ EXPECTED)}"

    for name in sorted(EXPECTED):
        directory = skill_root / name
        metadata = frontmatter((directory / "SKILL.md").read_text(encoding="utf-8"))
        assert metadata.get("name") == name, f"name mismatch in {name}"
        assert metadata.get("description"), f"missing description in {name}"
        agent = (directory / "agents" / "openai.yaml").read_text(encoding="utf-8")
        assert "display_name:" in agent and "short_description:" in agent
        assert "policy.products" not in agent and "products:" not in agent
        assert (directory / "references" / "model-notes.md").is_file()
        assert (directory / "references" / "examples.md").is_file()

    for relative in ("README.md", "install.sh", "install.ps1"):
        assert "__GITHUB_REPOSITORY__" not in (ROOT / relative).read_text(encoding="utf-8")

    print("Self-contained repository checks passed.")


if __name__ == "__main__":
    main()
