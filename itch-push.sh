#!/bin/bash

# itch-push.sh — push already-exported NumbersMaze artifacts to itch.io via butler.
#
# Push-only: this script never builds or exports. Run the Godot editor's
# export presets first (see docs/itch-app-setup.md).
#
# Prerequisites (all one-time, developer-side):
#   1. butler installed — either on PATH, or vendored at .tools/butler/butler.
#      To vendor into the repo (gitignored), run:
#        curl -L https://broth.itch.zone/butler/linux-amd64/LATEST/archive/default -o butler.zip
#        mkdir -p .tools/butler && unzip butler.zip -d .tools/butler && chmod +x .tools/butler/butler && rm butler.zip
#   2. `butler login` run once (opens a browser; writes butler's own credential store).
#   3. itch.conf filled with the real itch.io target (ITCH_USER, ITCH_GAME).

set -euo pipefail

cd "$(dirname "$0")"

# --- Load the itch.io target ---------------------------------------------
if [ ! -f itch.conf ]; then
    echo "ERROR: itch.conf not found — run: cp itch.conf.example itch.conf," >&2
    echo "  then fill ITCH_USER and ITCH_GAME with the real target." >&2
    exit 1
fi

# shellcheck disable=SC1091
source itch.conf

: "${ITCH_USER:?ERROR: itch.conf must define ITCH_USER}"
: "${ITCH_GAME:?ERROR: itch.conf must define ITCH_GAME}"

if [ "${ITCH_USER}" = "REPLACE_ME" ] || [ "${ITCH_GAME}" = "REPLACE_ME" ]; then
    echo "ERROR: itch.conf still carries REPLACE_ME placeholders — fill in the real itch.io target." >&2
    exit 1
fi

# --- Resolve butler: PATH first, then the vendored copy -------------------
if command -v butler >/dev/null 2>&1; then
    BUTLER="butler"
elif [ -x .tools/butler/butler ]; then
    BUTLER=".tools/butler/butler"
else
    echo "ERROR: butler not found on PATH and .tools/butler/butler is missing." >&2
    echo "  Vendor it (one-time):" >&2
    echo "    curl -L https://broth.itch.zone/butler/linux-amd64/LATEST/archive/default -o butler.zip" >&2
    echo "  Then authenticate (one-time): butler login" >&2
    exit 1
fi

# --- Artifact paths (operator config from itch.conf, with documented defaults)
ITCH_HTML5_DIR="${ITCH_HTML5_DIR:-tmp/html5}"
ITCH_ANDROID_APK="${ITCH_ANDROID_APK:-tmp/NumbersMaze.apk}"
ITCH_WINDOWS_EXE="${ITCH_WINDOWS_EXE:-tmp/NumbersMaze-x86_64.exe}"
ITCH_LINUX_BIN="${ITCH_LINUX_BIN:-tmp/NumbersMaze.x86_64}"
ITCH_MACOS_ZIP="${ITCH_MACOS_ZIP:-tmp/NumbersMaze-mac.zip}"

# --- Guard every artifact BEFORE any butler invocation --------------------
# (no partial publish sequence: a missing later artifact must not follow
# earlier successful pushes)
check_file() {
    if [ ! -f "$1" ]; then
        echo "ERROR: artifact not found: $1" >&2
        echo "  Export it first with the matching Godot editor preset" >&2
        echo "  (see docs/itch-app-setup.md)." >&2
        exit 1
    fi
}

check_html5_dir() {
    if [ ! -f "$1/index.html" ]; then
        echo "ERROR: HTML5 export directory not found, or index.html missing at its root: $1" >&2
        echo "  Export it with the HTML5 preset (index.html must sit at the" >&2
        echo "  build root — the form itch's HTML5 hosting expects;" >&2
        echo "  see docs/itch-app-setup.md)." >&2
        exit 1
    fi
}

check_html5_dir "${ITCH_HTML5_DIR}"
check_file "${ITCH_ANDROID_APK}"
check_file "${ITCH_WINDOWS_EXE}"
check_file "${ITCH_LINUX_BIN}"
check_file "${ITCH_MACOS_ZIP}"

# --- Push (idempotent patch pushes; first push creates the download) ------
echo "==> Pushing html5: ${ITCH_HTML5_DIR}"
"${BUTLER}" push "${ITCH_HTML5_DIR}" "${ITCH_USER}/${ITCH_GAME}:html5"

echo "==> Pushing android: ${ITCH_ANDROID_APK}"
"${BUTLER}" push "${ITCH_ANDROID_APK}" "${ITCH_USER}/${ITCH_GAME}:android"

echo "==> Pushing windows: ${ITCH_WINDOWS_EXE}"
"${BUTLER}" push "${ITCH_WINDOWS_EXE}" "${ITCH_USER}/${ITCH_GAME}:windows"

echo "==> Pushing linux: ${ITCH_LINUX_BIN}"
"${BUTLER}" push "${ITCH_LINUX_BIN}" "${ITCH_USER}/${ITCH_GAME}:linux"

echo "==> Pushing macos: ${ITCH_MACOS_ZIP}"
"${BUTLER}" push "${ITCH_MACOS_ZIP}" "${ITCH_USER}/${ITCH_GAME}:macos"

# --- Receipts -------------------------------------------------------------
echo "==> butler receipts:"
"${BUTLER}" status "${ITCH_USER}/${ITCH_GAME}:html5"
"${BUTLER}" status "${ITCH_USER}/${ITCH_GAME}:android"
"${BUTLER}" status "${ITCH_USER}/${ITCH_GAME}:windows"
"${BUTLER}" status "${ITCH_USER}/${ITCH_GAME}:linux"
"${BUTLER}" status "${ITCH_USER}/${ITCH_GAME}:macos"

echo "Done."
