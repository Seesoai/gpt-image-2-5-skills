#!/usr/bin/env python3
"""Insert a GitHub OWNER/REPO slug into the public install commands."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


def main() -> int:
    if len(sys.argv) != 2 or not re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", sys.argv[1]):
        print("Usage: python3 scripts/configure-repository.py OWNER/REPO", file=sys.stderr)
        return 2

    slug = sys.argv[1]
    root = Path(__file__).resolve().parent.parent
    catalog_path = root / "skills.json"
    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    previous_slug = catalog.get("repository", "")
    files = [root / "README.md", root / "install.sh", root / "install.ps1"]
    changed = 0

    for path in files:
        text = path.read_text(encoding="utf-8")
        updated = re.sub(
            r"(?<=DEFAULT_REPOSITORY=\")([^\"]*)(?=\")",
            slug,
            text,
        ) if path.name == "install.sh" else text
        updated = re.sub(
            r'(?<=\$Repository = \")([^\"]*)(?=\")',
            slug,
            updated,
        ) if path.name == "install.ps1" else updated
        updated = updated.replace("__GITHUB_REPOSITORY__", slug)
        if previous_slug:
            updated = updated.replace(previous_slug, slug)
        if updated != text:
            path.write_text(updated, encoding="utf-8")
            changed += 1

    if previous_slug != slug:
        catalog["repository"] = slug
        for skill in catalog.get("skills", []):
            for field in ("source_url", "install_command"):
                if previous_slug and field in skill:
                    skill[field] = skill[field].replace(previous_slug, slug)
        catalog_path.write_text(
            json.dumps(catalog, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        changed += 1

    print(f"Configured {changed} file(s) for https://github.com/{slug}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
