#!/usr/bin/env bash
set -euo pipefail

MEDIA_TYPE="application/vnd.buildstream.cas.tar.zst"
CACHE_DIR="${BST_CACHE_DIR:-${HOME}/.cache/buildstream}"
REF="${BST_CACHE_REF:-ghcr.io/lce-hub/emerald-buildstream-cache}"
KEY="${BST_CACHE_KEY:-}"
tmp=""

cleanup() {
    [ -z "${tmp}" ] || rm -rf "${tmp}"
}
trap cleanup EXIT

require_tools() {
    local tool
    for tool in "$@"; do
        command -v "${tool}" >/dev/null 2>&1 || {
            echo "${tool} is required but not on PATH" >&2
            exit 1
        }
    done
}

login() {
    if [ -n "${GH_TOKEN:-}" ] && [ -n "${GITHUB_ACTOR:-}" ]; then
        printf '%s' "${GH_TOKEN}" | oras login ghcr.io -u "${GITHUB_ACTOR}" --password-stdin >/dev/null
    fi
}

pull() {
    require_tools oras tar zstd
    login

    local tag
    for tag in ${KEY:+"${KEY}"} latest; do
        tmp="$(mktemp -d)"
        if ! oras pull "${REF}:${tag}" -o "${tmp}" >/dev/null 2>"${tmp}/err"; then
            if grep -qi 'not found' "${tmp}/err"; then
                echo "==> ${REF}:${tag} missing"
            else
                echo "==> ${REF}:${tag} pull failed, starting cold"
            fi
            rm -rf "${tmp}"
            tmp=""
            continue
        fi
        if [ ! -f "${tmp}/cache.tar.zst" ]; then
            echo "==> ${REF}:${tag} has no cache archive"
            rm -rf "${tmp}"
            tmp=""
            continue
        fi
        mkdir -p "${CACHE_DIR}"
        if zstd -d -c "${tmp}/cache.tar.zst" | tar -xf - -C "${CACHE_DIR}"; then
            echo "==> restored ${REF}:${tag}"
            rm -rf "${tmp}"
            tmp=""
            return 0
        fi
        rm -rf "${tmp}"
        tmp=""
    done
    echo "==> no usable cache, starting cold"
}

push() {
    require_tools oras tar zstd
    login
    tmp="$(mktemp -d)"
    tar -cf - -C "${CACHE_DIR}" --exclude 'cas/staging' --exclude 'cas/tmp' . | zstd -T0 >"${tmp}/cache.tar.zst"
    (
        cd "${tmp}"
        oras push "${REF}:latest" "cache.tar.zst:${MEDIA_TYPE}" >/dev/null
    )
    echo "==> pushed ${REF}:latest"
    if [ -n "${KEY}" ]; then
        (
            cd "${tmp}"
            oras push "${REF}:${KEY}" "cache.tar.zst:${MEDIA_TYPE}" >/dev/null
        )
        echo "==> pushed ${REF}:${KEY}"
    fi
}

case "${1:-}" in
pull) pull ;;
push) push ;;
*) echo "usage: $(basename "$0") {pull|push}" >&2; exit 2 ;;
esac
