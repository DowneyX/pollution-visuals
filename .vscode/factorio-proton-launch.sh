#!/usr/bin/env bash
set -euo pipefail

STEAM_ROOT="${STEAM_ROOT:-$HOME/.local/share/Steam}"
COMPAT_DATA_PATH="${STEAM_COMPAT_DATA_PATH:-$STEAM_ROOT/steamapps/compatdata/427520}"
FACTORIO_EXE="${FACTORIO_EXE:-$STEAM_ROOT/steamapps/common/Factorio/bin/x64/factorio.exe}"

# Allow overriding Proton path via env, otherwise pick the first installed candidate.
if [[ -n "${FACTORIO_PROTON_BIN:-}" ]]; then
  PROTON_BIN="$FACTORIO_PROTON_BIN"
else
  PROTON_BIN=""
  for candidate in \
    "$STEAM_ROOT/steamapps/common/Proton 10.0/proton" \
    "$STEAM_ROOT/steamapps/common/Proton - Experimental/proton" \
    "$STEAM_ROOT/steamapps/common/Proton Hotfix/proton"; do
    if [[ -x "$candidate" ]]; then
      PROTON_BIN="$candidate"
      break
    fi
  done
fi

if [[ -z "$PROTON_BIN" || ! -x "$PROTON_BIN" ]]; then
  echo "Could not find a Proton launcher. Set FACTORIO_PROTON_BIN to a valid proton path." >&2
  exit 1
fi

if [[ ! -f "$FACTORIO_EXE" ]]; then
  echo "Factorio executable not found at: $FACTORIO_EXE" >&2
  exit 1
fi

export STEAM_COMPAT_CLIENT_INSTALL_PATH="$STEAM_ROOT"
export STEAM_COMPAT_DATA_PATH="$COMPAT_DATA_PATH"

exec "$PROTON_BIN" run "$FACTORIO_EXE" "$@"
