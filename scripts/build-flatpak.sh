#!/usr/bin/env bash
set -euo pipefail

MANIFEST=io.github.Emerald_Legacy_Launcher.Emerald_Legacy_Launcher.yml
SRC=.flatpak-src
REPO=flatpak-repo

sudo apt-get update -qq
sudo apt-get install -y -qq flatpak flatpak-builder
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --user -y flathub org.gnome.Platform//49 org.gnome.Sdk//49

rm -rf "$SRC" "$REPO" build-flatpak
just bst artifact checkout launcher/src.bst --directory "/src/${SRC}"

cd "$SRC/flatpak"
flatpak-builder --user --install-deps-from=flathub --force-clean --repo="../../${REPO}" build-flatpak "$MANIFEST"
flatpak build-bundle "../../${REPO}" ../../emerald-launcher.flatpak \
  io.github.Emerald_Legacy_Launcher.Emerald_Legacy_Launcher
