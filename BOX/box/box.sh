#!/bin/bash
set -e

apt-get update
apt-get install -y net-tools isc-dhcp-server traceroute mtr tcpdump iperf3 nftables iptables iproute2 iputils-ping procps openvpn

# Activer le routage IPv4
echo 1 > /proc/sys/net/ipv4/ip_forward

# DÉFINITION DE LA ROUTE PAR DÉFAUT (Vers l'opérateur)
# On supprime la route par défaut de Docker
ip route del default || true
# On ajoute la route vers le routeur de l'AS
ip route add default via 120.0.16.99 dev eth0

# --- CONFIGURATION DHCP ---
# On dit au serveur DHCP d'écouter UNIQUEMENT sur le LAN (eth1)
# On modifie le fichier de config par défaut de Debian
sed -i 's/INTERFACESv4=""/INTERFACESv4="eth1"/' /etc/default/isc-dhcp-server

# On s'assure que le fichier dhcpd.leases existe (sinon le serveur plante)
touch /var/lib/dhcp/dhcpd.leases

# Démarrage du serveur DHCP
service isc-dhcp-server start || /usr/sbin/dhcpd -4 -f -d --no-pid -cf /etc/dhcp/dhcpd.conf eth1 &

# --- CONFIGURATION IPTABLES ---
# Nettoyage iptables
iptables -F
iptables -t nat -F
# NAT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# Bloquer toutes les requêtes sauf celles filtrées
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
# Accepter Ping
iptables -t filter -A OUTPUT -p icmp -j ACCEPT
iptables -t filter -A INPUT -p icmp -j ACCEPT
iptables -t filter -A FORWARD -p icmp -j ACCEPT
# Accepter le trafic entre LAN et WAN
iptables -t filter -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -t filter -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
# Accepter DNS
iptables -t filter -A FORWARD -d 120.0.54.3/23 -p udp --dport 53 -j ACCEPT
iptables -t filter -A FORWARD -s 120.0.54.3/23 -p udp --sport 53 -j ACCEPT
# Accepter HTTP
iptables -t filter -A FORWARD -d 120.0.54.5/23 -p tcp --dport 80 -j ACCEPT
iptables -t filter -A FORWARD -s 120.0.54.5/23 -p tcp --sport 80 -j ACCEPT


# Garder le conteneur en vie
tail -f /dev/null
