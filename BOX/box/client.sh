#!/bin/bash
set -e

# Installation
apt-get update
apt-get install -y net-tools isc-dhcp-server traceroute mtr tcpdump iperf3 nftables iptables iproute2 iputils-ping procps

# On nettoie l'IP que Docker a pu donner au démarrage
ip addr flush dev eth0

# Obtention d'une IP via DHCP
dhclient

# Garder le conteneur en vie
tail -f /dev/null