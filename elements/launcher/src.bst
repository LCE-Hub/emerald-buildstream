kind: manual

description: Pinned Project Radium source tree and submodules

sources:
- kind: git_repo
  url: github:LCE-Hub/LCE-Emerald-Launcher.git
  ref: '%{launcher-ref}'

- kind: git_module
  path: DiamondRuntime
  url: github:LCE-Hub/DiamondRuntime.git
  ref: '%{diamondruntime-ref}'

- kind: git_module
  path: GoldMapper
  url: github:LCE-Hub/GoldMapper.git
  ref: '%{goldmapper-ref}'

- kind: git_module
  path: Lazuli
  url: github:LCE-Hub/Lazuli
  ref: '%{lazuli-ref}'

- kind: git_module
  path: flatpak/shared-modules
  url: github:flathub/shared-modules.git
  ref: '%{shared-modules-ref}'

- kind: git_module
  path: src/discord_ipc_cpp
  url: github:LCE-Hub/discordipc
  ref: '%{discord-ipc-cpp-ref}'
