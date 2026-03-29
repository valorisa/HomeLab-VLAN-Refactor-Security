# Tableau des VLAN — HomeLab VLAN Refactor

> Référentiel complet des VLAN, sous-réseaux, règles de sécurité et configurations DHCP

---

## 📊 Vue d'ensemble

| ID VLAN | Nom | Réseau | Passerelle | DHCP Range | Rôle Principal |
|---------|-----|--------|------------|------------|----------------|
| 10 | Admin | `10.20.10.0/24` | `10.20.10.254` | `.100-.200` | Management, NAS, PC principal |
| 50 | PC | `10.20.50.0/24` | `10.20.50.254` | `.100-.200` | PC secondaires, imprimantes |
| 99 | Native | *N/A* | *N/A* | *N/A* | VLAN natif des trunks |
| 100 | IoT | `10.20.100.0/24` | `10.20.100.254` | `.100-.200` | Objets connectés |
| 200 | VoIP | `10.20.200.0/24` | `10.20.200.254` | `.100-.200` | Téléphonie IP |
| 1000 | Merdouille | `10.20.1000.0/24` | `10.20.1000.254` | `.100-.200` | Transition temporaire |

---

## 🔐 Matrice de sécurité inter-VLAN

### Légende
| Symbole | Signification |
|---------|---------------|
| ✅ | Accès autorisé |
| ❌ | Accès interdit |
| ⚠️ | Accès restreint (ports/services spécifiques) |

### Tableau des flux autorisés

| Source → Destination | VLAN 10 (Admin) | VLAN 50 (PC) | VLAN 100 (IoT) | VLAN 200 (VoIP) | VLAN 1000 (Merdouille) | Internet |
|---------------------|-----------------|--------------|----------------|-----------------|------------------------|----------|
| **VLAN 10 (Admin)** | ✅ Local | ✅ ICMP, SSH | ⚠️ Management uniquement | ❌ | ️ Migration | ✅ Complet |
| **VLAN 50 (PC)** | ❌ | ✅ Local | ❌ | ❌ |  | ✅ Filtré |
| **VLAN 100 (IoT)** | ❌ | ❌ | ✅ Local | ❌ | ❌ | ❌ Isolé |
| **VLAN 200 (VoIP)** | ⚠️ SIP/RTP | ❌ | ❌ | ✅ Local | ❌ | ✅ SIP uniquement |
| **VLAN 1000 (Merdouille)** | ❌ | ❌ | ❌ | ❌ | ✅ Local | ❌ Isolé |

---

## 📋 Détail par VLAN

### 🔷 VLAN 10 — Admin

| Paramètre | Valeur |
|-----------|--------|
| **ID VLAN** | 10 |
| **Nom** | Admin |
| **Réseau** | `10.20.10.0/24` |
| **Passerelle** | `10.20.10.254` |
| **DHCP Range** | `10.20.10.100` - `10.20.10.200` |
| **Lease Time** | 24h |
| **DNS** | `10.20.10.254` (Windows Server) |

**Équipements concernés :**
- Fortigate 60F (interface de management)
- Cisco Catalyst 2960X (IP management)
- Proxmox VE (interface de management)
- TrueNAS Scale (interface de management)
- PC Admin principal (10Gb)
- Windows Server 2022 (DHCP/DNS/AD)

**Accès autorisés :**
- ✅ SSH/RDP depuis VLAN 10 uniquement
- ✅ HTTPS pour interfaces de management
- ✅ SNMP pour monitoring
- ✅ SMB/NFS pour accès NAS

---

### 🔷 VLAN 50 — PC

| Paramètre | Valeur |
|-----------|--------|
| **ID VLAN** | 50 |
| **Nom** | PC |
| **Réseau** | `10.20.50.0/24` |
| **Passerelle** | `10.20.50.254` |
| **DHCP Range** | `10.20.50.100` - `10.20.50.200` |
| **Lease Time** | 12h |
| **DNS** | `10.20.10.254` (Windows Server) |

**Équipements concernés :**
- PC bureaux utilisateurs
- Imprimantes réseau
- Scanners

**Accès autorisés :**
- ✅ Internet (filtré : HTTP, HTTPS, DNS)
- ❌ Accès VLAN Admin interdit
- ❌ Accès VLAN IoT interdit
- ✅ Impression vers imprimantes locales

---

### 🔷 VLAN 99 — Native

| Paramètre | Valeur |
|-----------|--------|
| **ID VLAN** | 99 |
| **Nom** | Native |
| **Réseau** | *Aucun* |
| **Usage** | VLAN natif des trunks |

**⚠️ Important :**
- Aucun équipement utilisateur ne doit être assigné au VLAN 99
- Utilisé uniquement pour le tagging 802.1Q
- Sécurité : empêche le VLAN hopping

---

### 🔷 VLAN 100 — IoT

| Paramètre | Valeur |
|-----------|--------|
| **ID VLAN** | 100 |
| **Nom** | IoT |
| **Réseau** | `10.20.100.0/24` |
| **Passerelle** | `10.20.100.254` |
| **DHCP Range** | `10.20.100.100` - `10.20.100.200` |
| **Lease Time** | 7 jours |
| **DNS** | `10.20.10.254` (Windows Server) |

**Équipements concernés :**
- Caméras de surveillance
- Capteurs environnementaux
- Dispositifs garage
- Objets connectés divers

**Accès autorisés :**
- ❌ Internet : **BLOQUÉ** (isolation totale)
- ❌ Autres VLAN : **BLOQUÉ**
- ✅ Management depuis VLAN Admin uniquement
- ✅ Communication locale entre dispositifs IoT (optionnel)

---

### 🔷 VLAN 200 — VoIP

| Paramètre | Valeur |
|-----------|--------|
| **ID VLAN** | 200 |
| **Nom** | VoIP |
| **Réseau** | `10.20.200.0/24` |
| **Passerelle** | `10.20.200.254` |
| **DHCP Range** | `10.20.200.100` - `10.20.200.200` |
| **Lease Time** | 24h |
| **DNS** | `10.20.10.254` (Windows Server) |
| **Option DHCP 66/150** | IP serveur TFTP (si besoin) |

**Équipements concernés :**
- Téléphones IP (Mytel 470, etc.)
- Passerelles VoIP
- Standard IPBX (si virtualisé)

**QoS (Quality of Service) :**
| Priorité | DSCP | Trafic |
|----------|------|--------|
| **EF (Expedited Forwarding)** | 46 | RTP (voix) |
| **AF41 (Assured Forwarding)** | 34 | SIP (signalisation) |
| **BE (Best Effort)** | 0 | Autre |

---

### 🔷 VLAN 1000 — Merdouille

| Paramètre | Valeur |
|-----------|--------|
| **ID VLAN** | 1000 |
| **Nom** | Merdouille |
| **Réseau** | `10.20.1000.0/24` |
| **Passerelle** | `10.20.1000.254` |
| **DHCP Range** | `10.20.1000.100` - `10.20.1000.200` |
| **Lease Time** | 1h (court pour nettoyage) |
| **Statut** | **Temporaire** |

**Usage :**
- VLAN de transition pendant la migration
- Appareils en attente d'affectation définitive
- Tests et débogage

**⚠️ Important :**
- Ce VLAN doit être **nettoyé après migration**
- Durée de vie maximale : 30 jours

---

## 🔄 Règles de routage inter-VLAN (Fortigate)

### Résumé des policies

| ID | Nom | Source | Destination | Action | Services | Log |
|----|-----|--------|-------------|--------|----------|-----|
| 1 | Admin-to-Internet | VLAN 10 | WAN | ✅ Accept | ALL | ✅ |
| 2 | PC-to-Internet | VLAN 50 | WAN | ✅ Accept | HTTP,HTTPS,DNS | ✅ |
| 3 | IoT-BLOCK | VLAN 100 | ANY | ❌ Deny | ALL | ✅ |
| 4 | Admin-to-IoT | VLAN 10 | VLAN 100 | ✅ Accept | SSH,HTTP,HTTPS | ✅ |
| 5 | VoIP-to-SIP | VLAN 200 | WAN | ✅ Accept | SIP,RTP | ✅ |
| 6 | Merdouille-BLOCK | VLAN 1000 | ANY | ❌ Deny | ALL | ✅ |

---

## 📊 Adressage IP réservé (Static DHCP)

| Équipement | MAC Address | IP Réservée | VLAN | Usage |
|------------|-------------|-------------|------|-------|
| Fortigate Mgmt | `XX:XX:XX:XX:XX:01` | `10.20.10.1` | 10 | Interface management |
| Cisco Switch | `XX:XX:XX:XX:XX:02` | `10.20.10.2` | 10 | Interface management |
| Windows Server | `XX:XX:XX:XX:XX:03` | `10.20.10.10` | 10 | DHCP/DNS/AD |
| Proxmox | `XX:XX:XX:XX:XX:04` | `10.20.10.20` | 10 | Hyperviseur |
| TrueNAS | `XX:XX:XX:XX:XX:05` | `10.20.10.30` | 10 | Stockage principal |
| QNAP Backup | `XX:XX:XX:XX:XX:06` | `10.20.10.40` | 10 | Sauvegarde |
| PC Admin | `XX:XX:XX:XX:XX:07` | `10.20.10.50` | 10 | Poste principal |
| Imprimante | `XX:XX:XX:XX:XX:08` | `10.20.50.10` | 50 | Impression réseau |
| Caméra Garage | `XX:XX:XX:XX:XX:09` | `10.20.100.10` | 100 | Surveillance |
| Téléphone Bureau 1 | `XX:XX:XX:XX:XX:10` | `10.20.200.10` | 200 | VoIP |

> 💡 **À compléter** avec les vraies adresses MAC de vos équipements.

---

## 🚨 Checklist de validation

### Avant déploiement

- [ ] Vérifier que tous les sous-réseaux ne se chevauchent pas
- [ ] Tester les règles firewall en lab isolé
- [ ] Valider les plages DHCP (suffisamment d'adresses)
- [ ] Documenter les adresses MAC pour DHCP statique
- [ ] Préparer un plan de rollback

### Après déploiement

- [ ] Ping test entre tous les VLAN (selon matrice)
- [ ] Vérifier l'attribution DHCP sur chaque VLAN
- [ ] Tester l'accès Internet depuis VLAN 50 (filtré)
- [ ] Vérifier l'isolation du VLAN 100 (IoT)
- [ ] Valider la QoS sur le VLAN 200 (VoIP)
- [ ] Confirmer le blocage du VLAN 1000 (Merdouille)

---

## 📚 Références

- Documentation Fortigate Firewall Policies : https://docs.fortinet.com/product/fortigate/6.4
- Cisco VLAN Configuration Guide : https://www.cisco.com/c/en/us/support/
- RFC 1918 (Adressage privé) : https://tools.ietf.org/html/rfc1918
- 802.1Q VLAN Tagging : https://standards.ieee.org/standard/802_1Q-2018.html

---
*Document généré automatiquement — Dernière mise à jour : 2026-03-29 22:41*