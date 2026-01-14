#!/bin/bash
set -e

# Obtenir une adresse IP via DHCP
dhclient eth0

# Démarrer Apache
service apache2 start

# Créer une page simple
echo "<html><body><h1>Serveur Entreprise Principal</h1><p>IP: $(hostname -I)</p></body></html>" > /var/www/html/index.html

# Garder le conteneur en vie
tail -f /dev/null