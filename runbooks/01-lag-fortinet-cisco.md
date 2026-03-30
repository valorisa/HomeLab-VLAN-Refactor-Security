# Runbook : Configuration LAG Fortinet ↔ Cisco

> Procédure pas-à-pas pour configurer le LACP (Link Aggregation Control Protocol) entre Fortigate 60F et Cisco Catalyst 2960X

---

## 📋 Informations générales

| Paramètre | Valeur |
|-----------|--------|
| **ID Runbook** | RB-001 |
| **Titre** | Configuration LAG Fortinet ↔ Cisco |
| **Version** | 1.0 |
| **Dernière mise à jour** | 2026-03-30 13:45 |
| **Auteur** | @valorisa |
| **Temps estimé** | 45 minutes |
| **Niveau de risque** | 🟠 Élevé (impact réseau) |
| **Fenêtre de maintenance** | 22:00 - 06:00 (heures creuses) |

---

## 🎯 Objectifs

- [ ] Configurer le LAG (Port-Channel) côté Fortigate 60F
- [ ] Configurer le LACP côté Cisco Catalyst 2960X
- [ ] Valider la redondance et le débit agrégé
- [ ] Tester le failover (déconnexion d'un lien)
- [ ] Documenter la configuration finale

---

## 📐 Prérequis

### Matériel requis

| Équipement | Modèle | Quantité | Rôle |
|------------|--------|----------|------|
| Firewall | Fortigate 60F | 1 | Master LAG |
| Switch | Cisco Catalyst 2960X | 1 | Slave LAG |
| Câbles Ethernet | RJ45 Cat6 | 2 | Liens LAG |
| Console | Câble RJ45-USB | 1 | Accès hors-bande |

### Informations réseau

| Paramètre | Valeur |
|-----------|--------|
| **Ports Fortigate** | port3, port4 |
| **Ports Cisco** | GigabitEthernet0/1, GigabitEthernet0/2 |
| **VLANs sur le trunk** | 10, 50, 99, 100, 200, 1000 |
| **VLAN Native** | 99 |
| **IP Management Fortigate** | 10.20.10.1/24 |
| **IP Management Cisco** | 10.20.10.2/24 |

### Backups requis (AVANT toute modification)

```bash
# Fortigate - Backup configuration
# GUI : System → Settings → Configuration → Backup
# CLI :
execute backup config flash "fg60f-backup-pre-lag.conf"

# Cisco - Backup configuration
copy running-config flash:catalyst-2960x-backup-pre-lag.conf
copy running-config tftp://10.20.10.40/catalyst-2960x-backup-pre-lag.conf
```

---

## ⚠️ Avertissements

| Risque | Impact | Mitigation |
|--------|--------|------------|
| Perte de connectivité pendant config | Interruption réseau | Avoir accès console physique |
| Mauvaise configuration LAG | Boucle réseau / blackout | Tester en lab d'abord |
| Ports mal sélectionnés | Perte d'accès management | Ne pas utiliser les ports de management |
| STP non configuré | Boucle de commutation | Activer Rapid-PVST+ |

---

## 🔧 Procédure de configuration

### Étape 1 : Préparation (15 minutes)

```bash
# 1.1 Vérifier l'état actuel des ports Fortigate
show system interface port3
show system interface port4

# 1.2 Vérifier l'état actuel des ports Cisco
show interface status
show interface GigabitEthernet0/1
show interface GigabitEthernet0/2

# 1.3 Noter les configurations actuelles (screenshot ou export)
# 1.4 Prévenir les utilisateurs de la fenêtre de maintenance
# 1.5 Avoir le câble console prêt en cas de problème
```

**Checklist :**
- [ ] Backup Fortigate effectué
- [ ] Backup Cisco effectué
- [ ] Accès console physique disponible
- [ ] Utilisateurs prévenus
- [ ] Fenêtre de maintenance confirmée

---

### Étape 2 : Configuration Fortigate 60F (15 minutes)

```fortinet
# 2.1 Créer l'interface LAG (lag1)
config system interface
    edit "lag1"
        set vdom "root"
        set ip 10.20.10.1 255.255.255.0
        set allowaccess ping https ssh http
        set type aggregate
        set member "port3" "port4"
        set lacp-mode active
        set lacp-speed 1G
        set l2forward enable
    next
end

# 2.2 Configurer les ports membres (port3, port4)
config system interface
    edit "port3"
        set vdom "root"
        set type physical
        set member "lag1"
    next
    edit "port4"
        set vdom "root"
        set type physical
        set member "lag1"
    next
end

# 2.3 Vérifier la configuration LAG
diagnose netlink aggregate name lag1
get system interface lag1
```

**Validation Fortigate :**
```bash
# Doit afficher :
# - lag1 status : up
# - member ports : port3, port4
# - lacp-mode : active
# - speed : 1Gbps (x2 = 2Gbps agrégés)
```

---

### Étape 3 : Configuration Cisco Catalyst 2960X (15 minutes)

```cisco
! 3.1 Accéder en mode configuration
enable
configure terminal

! 3.2 Créer le Port-Channel
interface Port-channel1
 description LAG-to-Fortigate-60F
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk native vlan 99
 switchport trunk allowed vlan 10,50,99,100,200,1000
 spanning-tree mode rapid-pvst
 spanning-tree portfast trunk
 no shutdown
exit

! 3.3 Configurer les ports physiques membres
interface GigabitEthernet0/1
 description LAG-Member-1-to-Fortigate-port3
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk native vlan 99
 switchport trunk allowed vlan 10,50,99,100,200,1000
 channel-group 1 mode active
 spanning-tree portfast trunk
 no shutdown
exit

interface GigabitEthernet0/2
 description LAG-Member-2-to-Fortigate-port4
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk native vlan 99
 switchport trunk allowed vlan 10,50,99,100,200,1000
 channel-group 1 mode active
 spanning-tree portfast trunk
 no shutdown
exit

! 3.4 Sauvegarder la configuration
write memory
copy running-config startup-config
```

**Validation Cisco :**
```bash
# Vérifier le Port-Channel
show etherchannel summary
show etherchannel port-channel

# Vérifier les ports
show interface Port-channel1
show interface GigabitEthernet0/1
show interface GigabitEthernet0/2

# Vérifier le trunk
show interface trunk
```

**Sortie attendue :**
```
Group  Port-channel  Protocol    Ports
------+-------------+-----------+-----------------------------------------------
1      Po1(SU)       LACP        Gi0/1(P)    Gi0/2(P)

SU = Layer2, In use
P  = Bundled in port-channel
```

---

### Étape 4 : Tests de validation (15 minutes)

```bash
# 4.1 Test de connectivité de base
ping 10.20.10.1  # Fortigate
ping 10.20.10.2  # Cisco

# 4.2 Test de débit (optionnel avec iPerf3)
# Sur un PC connecté au VLAN 10 :
iperf3 -c 10.20.10.30 -t 30  # TrueNAS pendant 30 secondes

# 4.3 Test de failover (déconnecter un lien)
# Débrancher physiquement le câble de port3 (Fortigate) / Gi0/1 (Cisco)
# Observer :
# - Le trafic doit continuer sans interruption
# - Le LAG doit rester up avec 1 lien restant
# - Rebrancher après 30 secondes

# 4.4 Vérifier les logs après failover
# Fortigate :
get log event | filter field subtype eq lacp

# Cisco :
show logging | include LACP|Port-channel
```

**Checklist de validation :**
- [ ] Ping Fortigate : ✅ OK
- [ ] Ping Cisco : ✅ OK
- [ ] Port-channel status : ✅ SU (Layer2, In use)
- [ ] Ports membres : ✅ Bundled (P)
- [ ] Test failover : ✅ Trafic continu
- [ ] Logs LACP : ✅ Aucun erreur

---

## 🚨 Procédure de rollback

### Si la configuration échoue

```bash
# FORTIGATE - Restaurer le backup
execute restore config flash "fg60f-backup-pre-lag.conf"
execute reboot

# CISCO - Restaurer le backup
copy flash:catalyst-2960x-backup-pre-lag.conf running-config
write memory
reload
```

### Timeline de rollback

| Temps écoulé | Action |
|-------------|--------|
| 0-5 min | Tenter de corriger la configuration |
| 5-10 min | Si échec, initier le rollback |
| 10-15 min | Rollback complété, vérifier connectivité |
| 15-30 min | Post-mortem et documentation |

---

## 📊 Monitoring post-déploiement

### Métriques à surveiller

| Métrique | Seuil d'alerte | Outil |
|----------|----------------|-------|
| Utilisation LAG | > 80% | PRTG / Grafana |
| Erreurs LACP | > 0 | Fortigate logs |
| État des ports | Down | SNMP polling |
| Latence | > 5ms | Ping monitoring |

### Commandes de monitoring régulières

```bash
# Fortigate - Quotidien
diagnose netlink aggregate name lag1
get system interface lag1

# Cisco - Quotidien
show etherchannel summary
show interface Port-channel1 | include rate
```

---

## 📝 Checklist finale

### Avant clôture

- [ ] Configuration LAG validée des deux côtés
- [ ] Test de failover réussi
- [ ] Logs vérifiés (aucune erreur LACP)
- [ ] Monitoring configuré
- [ ] Documentation mise à jour dans ce repo
- [ ] Backup post-configuration effectué
- [ ] Utilisateurs informés de la fin de maintenance

### Backups post-configuration

```bash
# Fortigate - Nouveau backup
execute backup config flash "fg60f-backup-post-lag-DATE.conf"

# Cisco - Nouveau backup
copy running-config flash:catalyst-2960x-backup-post-lag-DATE.conf
copy running-config tftp://10.20.10.40/catalyst-2960x-backup-post-lag-DATE.conf
```

---

## 🔗 Références

| Document | Lien |
|----------|------|
| Fortinet LAG Configuration | https://docs.fortinet.com/document/fortigate/6.4/cookbook/... |
| Cisco EtherChannel Guide | https://www.cisco.com/c/en/us/support/docs/lan-switching/etherchannel/... |
| IEEE 802.3ad (LACP) | https://standards.ieee.org/standard/802_3ad-2000.html |
| Runbook template | `runbooks/README.md` (dans ce repo) |

---

## 📞 Contacts d'urgence

| Rôle | Personne | Contact |
|------|----------|---------|
| Admin réseau | @valorisa | [À compléter] |
| Support Fortinet | [Fournisseur] | [À compléter] |
| Support Cisco | [Fournisseur] | [À compléter] |

---

## 📈 Historique des versions

| Version | Date | Auteur | Changements |
|---------|------|--------|-------------|
| 1.0 | 2026-03-30 13:45 | @valorisa | Version initiale |
| | | | |

---
*Document généré automatiquement — Dernière mise à jour : 2026-03-30 13:45*  
*Prochaine review : 2026-03-30 13:45 + 6 mois*