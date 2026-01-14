#!/bin/bash
set -e

# Obtenir une adresse IP via DHCP
dhclient eth0

# Configurer SSH
mkdir -p /var/run/sshd
echo 'root:root' | chpasswd
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Démarrer SSH
service ssh start

# Garder le conteneur en vie
tail -f /dev/null