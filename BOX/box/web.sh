#!/bin/bash
set -e

echo ">>> DÉMARRAGE DU SERVEUR WEB <<<"
apt-get update
apt-get install -y apache2 net-tools isc-dhcp-server traceroute mtr tcpdump iperf3 nftables iptables iproute2 iputils-ping procps

# Création de la page (petit exemple de site web)
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head><title>Site Box 1</title></head>
<body>
    <h1 style="color:blue">Serveur Web Box 1</h1>
    <p>Hébergé en 192.168.20.20</p>
</body>
</html>
EOF

# Démarrage du serveur web
apache2ctl -D FOREGROUND
# Garder le conteneur en vie
tail -f /dev/null