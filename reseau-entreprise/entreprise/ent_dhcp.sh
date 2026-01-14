#!/bin/bash
set -e

# Activer le routage IPv4
echo 1 > /proc/sys/net/ipv4/ip_forward

# DÉFINITION DES INTERFACES POUR DHCP
# DHCP écoute sur eth0 (net_ent_main) et eth1 (net_ent_secondary)
sed -i 's/INTERFACESv4=""/INTERFACESv4="eth0 eth1"/' /etc/default/isc-dhcp-server

# S'assurer que le fichier dhcpd.leases existe
touch /var/lib/dhcp/dhcpd.leases

# Démarrer le serveur DHCP
dhcpd -4 -f -d --no-pid -cf /etc/dhcp/dhcpd.conf eth0 eth1 &

# Garder le conteneur en vie
tail -f /dev/null