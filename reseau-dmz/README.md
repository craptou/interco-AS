# Réseau DMZ

Ce dossier crée un serveur web, un serveur DNS et un pare-feu dans la DMZ.

Services:
- `dmz-web` : serveur web (nginx) sur le réseau DMZ avec IP fixe `120.0.24.10`.
- `dmz-dns` : serveur DNS (dnsmasq) sur `120.0.24.11`, héberge la zone `dmz.local`.
- `dmz-fw`  : pare-feu (nftables) avec interfaces sur `net_dmz` (120.0.24.5) et `net_core` (120.0.31.5).

Démarrage :
```bash
cd reseau-dmz
docker compose up -d
```

Tests :
- Ping et HTTP :
  - `ping -c 4 120.0.24.10`
  - `curl http://120.0.24.10`
- DNS :
  - `dig @120.0.24.11 dmz-web.dmz.local` (ou `nslookup dmz-web.dmz.local 120.0.24.11`)
- Pare-feu :
  - Depuis un conteneur connecté à `net_core` (ex : `core-router`), `curl http://120.0.24.10` doit fonctionner.
  - Connexions non autorisées par les règles nftables seront bloquées.

Remarques :
- Ce `docker-compose` se connecte à des réseaux externes `core_net_dmz` et `core_net_core` (définis dans `core/docker-compose.yml`).
- Si les réseaux n'existent pas, démarre d'abord les services du dossier `core` (voir `core/README.md`).
- Le script `dmz/fw_rules.sh` configure des règles de base; adapte-les selon ta politique de sécurité.
