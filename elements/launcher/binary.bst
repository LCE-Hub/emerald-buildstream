kind: manual

description: Build the Radium launcher and package it as a zstd tarball

build-depends:
- launcher/src.bst
- toolchains/pugixml.bst
- toolchains/nlohmann-json.bst
- toolchains/stb.bst
- toolchains/miniaudio.bst
- freedesktop-sdk.bst:public-stacks/runtime-gnu.bst
- freedesktop-sdk.bst:components/gcc.bst
- freedesktop-sdk.bst:components/cmake.bst
- freedesktop-sdk.bst:bootstrap/make.bst
- freedesktop-sdk.bst:components/pkg-config.bst
- freedesktop-sdk.bst:components/curl.bst
- freedesktop-sdk.bst:components/libarchive.bst
- freedesktop-sdk.bst:components/sqlite.bst
- freedesktop-sdk.bst:components/sdl3.bst
- freedesktop-sdk.bst:components/sdl3-ttf.bst
- freedesktop-sdk.bst:components/tar.bst
- freedesktop-sdk.bst:components/zstd.bst

config:
  install-commands:
  - |
    cmake -S . -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DEMERALD_USE_SYSTEM_DEPS=ON \
      -DEMERALD_BUILD_GOLDMAPPER=OFF \
      -DLAZULI_FETCH_DEPS=OFF \
      -DEMERALD_SYSTEM_STB_DIR=/usr/include/stb
  - cmake --build build --parallel
  - |
    mkdir -p bundle/usr/share/emerald-launcher
    install -Dm755 build/src/emerald-legacy-launcher bundle/usr/bin/emerald-legacy-launcher
    cp -a public resources UiDocs bundle/usr/share/emerald-launcher/
    install -Dm644 flatpak/io.github.Emerald_Legacy_Launcher.Emerald_Legacy_Launcher.desktop \
      bundle/usr/share/applications/io.github.Emerald_Legacy_Launcher.Emerald_Legacy_Launcher.desktop
    install -Dm644 public/images/icon.png \
      bundle/usr/share/icons/hicolor/512x512/apps/io.github.Emerald_Legacy_Launcher.Emerald_Legacy_Launcher.png
  - |
    tar --zstd -cf '%{install-root}/emerald-launcher.tar.zst' -C bundle \
      usr/bin/emerald-legacy-launcher \
      usr/share/emerald-launcher \
      usr/share/applications \
      usr/share/icons
