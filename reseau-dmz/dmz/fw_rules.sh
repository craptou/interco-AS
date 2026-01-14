#!/bin/bash
set -e

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# Flush existing rules
nft flush ruleset || true

# Basic nftables rules: allow DNS and HTTP from core to dmz, allow established
nft -f - <<'EOF'
table inet filter {
  chain input {
    type filter hook input priority 0; policy accept;
  }
  chain forward {
    type filter hook forward priority 0; policy drop;
    # allow established / related
    ct state established,related accept
    # allow core -> dmz: HTTP
    ip saddr 120.0.31.0/24 ip daddr 120.0.24.0/22 tcp dport 80 accept
    # allow core -> dmz: DNS (TCP/UDP 53)
    ip saddr 120.0.31.0/24 ip daddr 120.0.24.0/22 udp dport 53 accept
    ip saddr 120.0.31.0/24 ip daddr 120.0.24.0/22 tcp dport 53 accept
    # allow dmz -> core DNS (outbound queries)
    ip saddr 120.0.24.0/22 ip daddr 120.0.31.0/24 udp dport 53 accept
  }
  chain output {
    type filter hook output priority 0; policy accept;
  }
}
EOF

# Show rules
nft list ruleset

# Keep container alive
tail -f /dev/null
