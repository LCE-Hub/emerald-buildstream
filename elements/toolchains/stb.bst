kind: manual

description: stb headers for the offline launcher build

build-depends:
- freedesktop-sdk.bst:public-stacks/runtime-gnu.bst

sources:
- kind: git_repo
  url: github:nothings/stb.git
  ref: '%{stb-ref}'

config:
  install-commands:
  - install -Dm644 stb_image.h '%{install-root}/usr/include/stb/stb_image.h'
  - install -Dm644 stb_image_write.h '%{install-root}/usr/include/stb/stb_image_write.h'
