kind: manual

description: Pinned appimagetool release binary

build-depends:
- freedesktop-sdk.bst:public-stacks/runtime-gnu.bst

sources:
- kind: remote
  filename: appimagetool
  executable: true
  url: github:AppImage/appimagetool/releases/download/%{appimagetool-version}/appimagetool-%{arch}.AppImage
  (?):
  - arch == 'x86_64':
      ref: '%{appimagetool-x86_64-sha256}'
  - arch == 'aarch64':
      ref: '%{appimagetool-aarch64-sha256}'

config:
  install-commands:
  - install -Dm755 appimagetool '%{install-root}/usr/bin/appimagetool'
