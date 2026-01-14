# Réseau Entreprise

Cette partie configure les services du réseau entreprise de l'AS avec DHCP.

## Services

- **ent-dhcp**: Serveur DHCP pour les réseaux entreprise (120.0.28.0/23 et 120.0.30.0/24)
- **ent-server-main**: Serveur web sur le réseau entreprise principal (IP fixe: 120.0.28.10 via DHCP)
- **ent-server-secondary**: Serveur SSH sur le réseau entreprise secondaire (IP fixe: 120.0.30.10 via DHCP)
- **ent-client**: Client qui teste la connectivité (IP fixe: 120.0.28.20 via DHCP)

## Utilisation

# Démarrer les services entreprise
docker compose up -d

# Vérifier les conteneurs
docker ps

# Entrer dans le client
docker exec -it ent-client bash

# Tester la connectivité
ping 120.0.28.10
curl http://120.0.28.10