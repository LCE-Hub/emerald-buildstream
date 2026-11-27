kind: manual

description: nanosvg headers required by Lazuli

build-depends:
- freedesktop-sdk.bst:public-stacks/runtime-gnu.bst

sources:
- kind: git_repo
  url: github:memononen/nanosvg.git
  ref: '%{nanosvg-ref}'

config:
  install-commands:
  - install -Dm644 src/nanosvg.h '%{install-root}/usr/include/nanosvg/nanosvg.h'
  - install -Dm644 src/nanosvgrast.h '%{install-root}/usr/include/nanosvg/nanosvgrast.h'
