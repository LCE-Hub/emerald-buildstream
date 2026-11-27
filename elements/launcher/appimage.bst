kind: manual

description: Assemble the Radium launcher AppImage from the binary tarball

build-depends:
- launcher/binary.bst
- toolchains/appimagetool.bst
- toolchains/type2-runtime.bst
- freedesktop-sdk.bst:public-stacks/runtime-gnu.bst
- freedesktop-sdk.bst:bootstrap/bash.bst
- freedesktop-sdk.bst:bootstrap/coreutils.bst
- freedesktop-sdk.bst:components/tar.bst
- freedesktop-sdk.bst:components/zstd.bst
- freedesktop-sdk.bst:components/file.bst

config:
  install-commands:
  - |
    mkdir -p AppDir
    tar --zstd -xf /emerald-launcher.tar.zst -C AppDir
    cat > AppDir/AppRun <<'EOF'
    #!/bin/sh
    exec "$(dirname "$0")/usr/bin/emerald-legacy-launcher" "$@"
    EOF
    chmod 755 AppDir/AppRun
    ln -s usr/share/icons/hicolor/512x512/apps/io.github.Emerald_Legacy_Launcher.Emerald_Legacy_Launcher.png AppDir/.DirIcon
    ln -s usr/share/icons/hicolor/512x512/apps/io.github.Emerald_Legacy_Launcher.Emerald_Legacy_Launcher.png AppDir/io.github.Emerald_Legacy_Launcher.Emerald_Legacy_Launcher.png
    ln -s usr/share/applications/io.github.Emerald_Legacy_Launcher.Emerald_Legacy_Launcher.desktop AppDir/io.github.Emerald_Legacy_Launcher.Emerald_Legacy_Launcher.desktop
  - |
    APPIMAGE_EXTRACT_AND_RUN=1 appimagetool --runtime-file /usr/share/appimage/runtime \
      AppDir '%{install-root}/emerald-launcher-%{arch}.AppImage'
