kind: manual

description: Pinned AppImage type2 runtime

build-depends:
- freedesktop-sdk.bst:public-stacks/runtime-gnu.bst

sources:
- kind: remote
  filename: runtime
  executable: true
  url: github:AppImage/type2-runtime/releases/download/%{type2-runtime-version}/runtime-%{arch}
  (?):
  - arch == 'x86_64':
      ref: '%{type2-runtime-x86_64-sha256}'
  - arch == 'aarch64':
      ref: '%{type2-runtime-aarch64-sha256}'

config:
  install-commands:
  - install -Dm755 runtime '%{install-root}/usr/share/appimage/runtime'
