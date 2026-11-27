#!/usr/bin/env python3
import hashlib
import re
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
VERSIONS = ROOT / "include/versions.yml"

SOURCES = [
    ("appimagetool-version", "appimagetool-{arch}-sha256", "https://github.com/AppImage/appimagetool/releases/download/{version}/appimagetool-{arch}.AppImage"),
]

ARCHES = ["x86_64", "aarch64"]


def read_versions(text):
    values = {}
    for line in text.splitlines():
        match = re.match(r'^  ([A-Za-z0-9_-]+):\s*"([^"]*)"', line)
        if match:
            values[match.group(1)] = match.group(2)
    return values


def sha256(url):
    request = urllib.request.Request(url, headers={"User-Agent": "emerald-buildstream-update-pins/1.0"})
    with urllib.request.urlopen(request, timeout=120) as response:
        digest = hashlib.sha256()
        while chunk := response.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def set_key(text, key, value):
    pattern = re.compile(rf'^(\s*{re.escape(key)}:\s*)"[^"]*"', re.MULTILINE)
    if not pattern.search(text):
        raise RuntimeError(f"{key} not found in {VERSIONS}")
    return pattern.sub(lambda m: f'{m.group(1)}"{value}"', text, count=1)


def main():
    text = VERSIONS.read_text()
    versions = read_versions(text)
    updates = {}
    for version_key, hash_key, template in SOURCES:
        for arch in ARCHES:
            url = template.format(version=versions[version_key], arch=arch)
            updates[hash_key.format(arch=arch)] = sha256(url)

    changed = False
    for key, value in updates.items():
        if versions.get(key) != value:
            print(f"{key}: {versions.get(key)} -> {value}")
            text = set_key(text, key, value)
            changed = True

    if changed:
        VERSIONS.write_text(text)
    else:
        print("Pins are current")
    return 0


if __name__ == "__main__":
    sys.exit(main())
