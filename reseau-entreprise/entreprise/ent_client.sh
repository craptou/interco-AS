#!/bin/bash
set -e

# Obtenir une adresse IP via DHCP
dhclient eth0

# Ping les serveurs
ping -c 4 120.0.28.10 &
ping -c 4 120.0.30.10 &

# Tester HTTP
sleep 5
curl http://120.0.28.10

# Garder le conteneur en vie
tail -f /dev/null