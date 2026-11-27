kind: manual

description: miniaudio header for the offline launcher build

build-depends:
- freedesktop-sdk.bst:public-stacks/runtime-gnu.bst

sources:
- kind: git_repo
  url: github:mackron/miniaudio.git
  ref: '%{miniaudio-ref}'

config:
  install-commands:
  - install -Dm644 miniaudio.h '%{install-root}/usr/include/miniaudio.h'
