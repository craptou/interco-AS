Choix techniques:
Simulation du réseau via Docker plutôt que des VM :
→ plus léger, plus facilement partageable, reproductible sur les machines du groupe.
Utilisation de FRRouting (FRR) pour implémenter les protocoles de routage :
-OSPF pour le routage interne à l’AS (intra-AS)
-BGP pour le routage externe entre AS

Mise en place de l’AS Core:
Création d’un conteneur core-router connecté à 6 réseaux Docker :
-net_core : 120.0.31.0/24
-net_dmz : 120.0.24.0/22
-net_ent_main : 120.0.28.0/23
-net_ent_secondary : 120.0.30.0/24
-net_box : 120.0.16.0/21
-net_inter_as : 200.0.0.0/29
Configuration des interfaces FRR avec des IP .2 sur chaque réseau (Docker gardant .1 pour les gateways).

Routage interne OSPF:
Mise en place d’un domaine OSPF area 0 unique sur tout l’AS.
Activation d’OSPF sur le core-router :
-120.0.31.0/24 (backbone interne)
-120.0.24.0/22 (DMZ)
-120.0.28.0/23 (Entreprise principale)
-120.0.30.0/24 (Entreprise secondaire)
-120.0.16.0/21 (réseau Box)
Ajout de trois autres routeurs :
-dmz-router : connecté à net_core + net_dmz
-ent-router : connecté à net_core + net_ent_main
-box-router : connecté à net_core + net_box
Configuration OSPF sur ces routeurs pour qu’ils annoncent leurs réseaux à l’AS.

Routage externe BGP:
Mise en place d’un routeur asn-router représentant l’AS voisin (AS 65002), connecté à net_inter_as (200.0.0.0/29).
Configuration BGP :
-core-router = AS 65001, neighbor 200.0.0.3 (AS 65002)
-asn-router = AS 65002, neighbor 200.0.0.2 (AS 65001)
Export d’un préfixe fictif 203.0.113.0/24 depuis l’AS voisin, appris par le core-router via BGP.

Utilisation:
# Arrête proprement l'infrastructure si elle tourne déjà
docker compose down
# Nettoye les réseaux Docker inutilisés (évite les conflits IP)
docker network prune
y
# Démarre tous les routeurs (core-router, dmz-router, ent-router, asn-router)
docker compose up -d
# Liste les conteneurs
docker ps

Test:
# Entrer dans core-router
docker exec -it core-router bash
# Lancer l'interface FRR
vtysh
# Voir les interfaces et leurs adresses IP
show ip interface brief
# Voir les voisins OSPF
show ip ospf neighbor
# Voir les routes apprises via OSPF
show ip route ospf
# dmz-router sur le réseau core
ping 120.0.31.3
# dmz-router sur le réseau DMZ
ping 120.0.24.3
# ent-router sur le réseau core
ping 120.0.31.4
# ent-router sur le réseau entreprise principale
ping 120.0.28.3


