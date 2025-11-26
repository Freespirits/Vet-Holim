#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${PWD}"
FLUTTER_ROOT="${FLUTTER_ROOT:-$ROOT_DIR/.flutter}"
FLUTTER_INSTALL_DIR="${FLUTTER_INSTALL_DIR:-$FLUTTER_ROOT}"
NPM_CONFIG_REGISTRY="${NPM_CONFIG_REGISTRY:-https://registry.npmjs.org/}"
NPM_FALLBACK_REGISTRY="${NPM_FALLBACK_REGISTRY:-https://registry.npmmirror.com/}"

export FLUTTER_ROOT FLUTTER_INSTALL_DIR
export PATH="$FLUTTER_ROOT/flutter/bin:$PATH"

git config --global --add safe.directory "$FLUTTER_ROOT/flutter" >/dev/null 2>&1 || true
npm config set registry "$NPM_CONFIG_REGISTRY" --location=project >/dev/null 2>&1 || true

bash deploy/install_flutter.sh

if ! npm install --registry="$NPM_CONFIG_REGISTRY" --prefix server; then
  npm install --registry="$NPM_FALLBACK_REGISTRY" --prefix server
fi
