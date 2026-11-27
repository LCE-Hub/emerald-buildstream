kind: manual

description: nlohmann_json CMake package for the offline launcher build

build-depends:
- freedesktop-sdk.bst:public-stacks/runtime-gnu.bst
- freedesktop-sdk.bst:components/gcc.bst
- freedesktop-sdk.bst:components/cmake.bst
- freedesktop-sdk.bst:bootstrap/make.bst

sources:
- kind: git_repo
  url: github:nlohmann/json.git
  ref: '%{nlohmann-json-ref}'

config:
  install-commands:
  - cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DJSON_BuildTests=OFF
  - cmake --build build --parallel
  - cmake --install build --prefix '%{install-root}/usr'
