#!/usr/bin/env bash
set -euo pipefail

CHANNEL=${FLUTTER_CHANNEL:-stable}
VERSION=${FLUTTER_VERSION:-3.24.0}
INSTALL_ROOT="${FLUTTER_INSTALL_DIR:-$PWD/.flutter}"
TARBALL="flutter_linux_${VERSION}-${CHANNEL}.tar.xz"
URL="https://storage.googleapis.com/flutter_infra_release/releases/${CHANNEL}/linux/${TARBALL}"

if [ -x "$INSTALL_ROOT/flutter/bin/flutter" ]; then
  echo "Flutter already installed at $INSTALL_ROOT/flutter"
  exit 0
fi

echo "Installing Flutter ${VERSION}-${CHANNEL} to $INSTALL_ROOT"
mkdir -p "$INSTALL_ROOT"

curl -L "$URL" -o "$INSTALL_ROOT/$TARBALL"
tar -xf "$INSTALL_ROOT/$TARBALL" -C "$INSTALL_ROOT"
rm -f "$INSTALL_ROOT/$TARBALL"

git config --global --add safe.directory "$INSTALL_ROOT/flutter" >/dev/null 2>&1 || true
"$INSTALL_ROOT/flutter/bin/flutter" --version
