# emerald-buildstream

BuildStream definitions for LCE Emerald Launcher.

Branches:

- `init`: shared project config, GHCR cache helper, and CI.
- `radium`: C++ and SDL3 launcher from pull request 226.

The `radium` branch builds a binary tarball and an AppImage. The BuildStream cache is stored at `ghcr.io/lce-hub/emerald-buildstream-cache`.

Build locally with `just build` after installing Podman and BuildStream. Renovate runs in GitHub Actions and opens pull requests when a pinned version changes. `scripts/update_pins.py` recomputes the matching sha256 values in those pull requests.
