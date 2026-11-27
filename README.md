# emerald-buildstream

BuildStream definitions for LCE Emerald Launcher.

Branches:

- `init`: shared project config, GHCR cache helper, and CI.
- `radium`: C++ and SDL3 launcher from [pull request 226](https://github.com/LCE-Hub/LCE-Emerald-Launcher/pull/226).

CI builds a binary tarball, an AppImage, a Flatpak bundle, and an SPDX SBOM. The BuildStream cache is stored at `ghcr.io/lce-hub/emerald-buildstream-cache`.

Build locally with `just build` after installing Podman and BuildStream. Renovate runs in GitHub Actions and opens pull requests when a pinned tool version changes. `scripts/update_pins.py` recomputes the matching sha256 values in those pull requests.
