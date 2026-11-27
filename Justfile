podman := env("PODMAN", "podman")
bst2_image := env("BST2_IMAGE", "registry.gitlab.com/freedesktop-sdk/infrastructure/freedesktop-sdk-docker-images/bst2:64eb0b4930d57a92710822898fb73af6cc1ae35d")
final_element := env("FINAL_ELEMENT", "launcher/appimage.bst")
binary_element := "launcher/binary.bst"

bst *ARGS:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p "${HOME}/.cache/buildstream" .build-out
    {{podman}} run --rm --privileged --device /dev/fuse --network=host \
      -v "{{justfile_directory()}}:/src:rw" \
      -v "${HOME}/.cache/buildstream:/root/.cache/buildstream:rw" \
      -w /src "{{bst2_image}}" \
      bash -c 'bst --colors "$@"' -- --no-interactive {{ARGS}}

sbom:
    #!/usr/bin/env bash
    set -euo pipefail
    REF=$(sed -n 's/.*sbom-ref: "\([^"]*\)".*/\1/p' include/versions.yml)
    mkdir -p "${HOME}/.cache/buildstream" sbom_out
    {{podman}} run --rm --privileged --device /dev/fuse --network=host \
      -e "SBOM_REF=${REF}" \
      -e "COMMIT_SHA=${COMMIT_SHA:-$(git rev-parse HEAD)}" \
      -v "{{justfile_directory()}}:/src:rw" \
      -v "${HOME}/.cache/buildstream:/root/.cache/buildstream:rw" \
      -w /src "{{bst2_image}}" \
      bash -c 'python3 -m pip install --break-system-packages --quiet \
        "git+https://gitlab.com/BuildStream/buildstream-sbom.git@${SBOM_REF}" && \
        buildstream-sbom launcher/appimage.bst \
        --spdx-name emerald-launcher \
        --spdx-namespace "https://github.com/LCE-Hub/emerald-buildstream/sbom/${COMMIT_SHA}" \
        --spdx-creator "Tool: buildstream-sbom" \
        --deps all \
        --output /src/sbom_out/emerald-launcher.spdx.json'

cache-pull:
    ./scripts/bst-cache-oci.sh pull

cache-push:
    ./scripts/bst-cache-oci.sh push

validate:
    just bst show {{final_element}}

build:
    just bst build {{binary_element}}
    just bst build {{final_element}}

export:
    #!/usr/bin/env bash
    set -euo pipefail
    rm -rf .build-out
    just bst artifact checkout {{final_element}} --directory /src/.build-out
    just bst artifact checkout {{binary_element}} --directory /src/.build-out-binary

clean:
    rm -rf .build-out .build-out-binary
