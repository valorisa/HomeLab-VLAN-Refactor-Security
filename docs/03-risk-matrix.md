# Matrice des Risques — HomeLab VLAN Refactor

> Identification, évaluation et procédures de mitigation des risques liés à la migration VLAN

---

## 📊 Méthodologie d'évaluation

### Échelle de probabilité

| Niveau | Score | Description |
|--------|-------|-------------|
| **Très faible** | 1 | < 5% de chance de survenue |
| **Faible** | 2 | 5-20% de chance de survenue |
| **Moyen** | 3 | 20-50% de chance de survenue |
| **Élevé** | 4 | 50-80% de chance de survenue |
| **Très élevé** | 5 | > 80% de chance de survenue |

### Échelle d'impact

| Niveau | Score | Description |
|--------|-------|-------------|
| **Négligeable** | 1 | Aucun impact sur les services |
| **Mineur** | 2 | Impact limité, récupération rapide |
| **Modéré** | 3 | Impact notable, récupération < 1h |
| **Majeur** | 4 | Impact important, récupération < 4h |
| **Critique** | 5 | Impact sévère, récupération > 4h |

### Calcul du score de risque

```
Score de risque = Probabilité × Impact
```

| Score | Niveau de risque | Action requise |
|-------|------------------|----------------|
| 1-4 | 🟢 **Faible** | Accepter, surveiller |
| 5-9 | 🟡 **Modéré** | Mitiger, planifier |
| 10-16 | 🟠 **Élevé** | Prioriser, agir |
| 17-25 | 🔴 **Critique** | Immédiat, escalader |

---

## 🔴 Risques Critiques (Score 17-25)

### R01 — Perte de connectivité réseau complète

| Paramètre | Valeur |
|-----------|--------|
| **ID** | R01 |
| **Catégorie** | Disponibilité |
| **Probabilité** | 3 (Moyen) |
| **Impact** | 5 (Critique) |
| **Score** | **15** (Élevé) |
| **Statut** | ⚠️ À mitiger |

**Description :**
Perte totale de connectivité réseau pendant ou après la migration VLAN, affectant tous les utilisateurs et services.

**Causes potentielles :**
- Mauvaise configuration du trunk Fortinet ↔ Cisco
- Boucle réseau (STP non configuré)
- Erreur de tagging VLAN sur les ports critiques
- Panne matérielle simultanée (Fortigate + Cisco)

**Conséquences :**
- Interruption de tous les services réseau
- Impossibilité d'accéder aux serveurs (Proxmox, TrueNAS)
- Perte de productivité totale
- Impact financier potentiel

**Mitigation :**
| Action | Type | Statut |
|--------|------|--------|
| Conserver l'ancienne configuration en backup | Préventif | ✅ Fait |
| Tester en lab isolé avant déploiement | Préventif | ✅ Fait |
| Planifier la migration en heures creuses (22:00-06:00) | Préventif | ✅ Fait |
| Préparer un rollback rapide (< 15 min) | Correctif | ✅ Fait |
| Avoir un accès console physique aux équipements | Préventif | ✅ Fait |

**Procédure de rollback :**
```bash
# 1. Revenir à la configuration précédente sur Fortigate
restore config from backup "fg60f-backup-pre-migration.conf"

# 2. Rebooter le Fortigate si nécessaire
execute reboot

# 3. Restaurer la config Cisco
copy flash:cisco-backup-pre-migration.conf running-config
write memory

# 4. Vérifier la connectivité
ping 10.20.10.254
```

**Responsable :** @valorisa  
**Date de review :** À chaque changement majeur

---

### R02 — Corruption de données pendant la migration

| Paramètre | Valeur |
|-----------|--------|
| **ID** | R02 |
| **Catégorie** | Intégrité |
| **Probabilité** | 2 (Faible) |
| **Impact** | 5 (Critique) |
| **Score** | **10** (Élevé) |
| **Statut** | ⚠️ À mitiger |

**Description :**
Perte ou corruption de données sur les NAS (TrueNAS, QNAP) pendant la reconfiguration réseau.

**Causes potentielles :**
- Interruption brutale des transferts Rsync en cours
- Déconnexion réseau pendant une écriture sur le NAS
- Mauvaise configuration des shares SMB/NFS après migration

**Conséquences :**
- Perte de données critiques
- Fichiers corrompus irrécupérables
- Impact sur les sauvegardes

**Mitigation :**
| Action | Type | Statut |
|--------|------|--------|
| Arrêter tous les transferts avant migration | Préventif | ✅ Fait |
| Vérifier l'intégrité des données post-migration | Détection | ✅ Fait |
| Avoir une sauvegarde externe à jour | Préventif | ✅ Fait |
| Tester les accès shares après migration | Détection | ✅ Fait |

**Procédure de vérification :**
```bash
# 1. Vérifier l'intégrité TrueNAS
zpool status
zfs scrub tank

# 2. Vérifier les shares SMB
smbstatus
testparm

# 3. Vérifier les shares NFS
exportfs -v
showmount -e
```

**Responsable :** @valorisa  
**Date de review :** Avant et après migration

---

## 🟠 Risques Élevés (Score 10-16)

### R03 — Mauvaise segmentation VLAN (fuite de trafic)

| Paramètre | Valeur |
|-----------|--------|
| **ID** | R03 |
| **Catégorie** | Sécurité |
| **Probabilité** | 3 (Moyen) |
| **Impact** | 4 (Majeur) |
| **Score** | **12** (Élevé) |
| **Statut** | ⚠️ À mitiger |

**Description :**
Le trafic entre VLAN non autorisés peut passer à travers le firewall, compromettant l'isolation sécurité.

**Causes potentielles :**
- Règles firewall trop permissives
- Mauvaise configuration des ACL sur Cisco
- VLAN non tagués sur les mauvais ports

**Conséquences :**
- Dispositifs IoT peuvent accéder au VLAN Admin
- Faille de sécurité critique
- Non-conformité aux politiques de sécurité

**Mitigation :**
| Action | Type | Statut |
|--------|------|--------|
| Tester les flux inter-VLAN après migration | Détection | ✅ Planifié |
| Activer le logging sur toutes les règles firewall | Détection | ✅ Planifié |
| Review des règles par un pair | Préventif |  À faire |
| Utiliser des règles "deny all" par défaut | Préventif | ✅ Fait |

**Test de validation :**
```bash
# Depuis un PC VLAN 100 (IoT), tester l'accès au VLAN 10 (Admin)
ping 10.20.10.254  # Doit ÉCHOUER
ssh 10.20.10.254   # Doit ÉCHOUER

# Depuis un PC VLAN 10 (Admin), tester l'accès au VLAN 100 (IoT)
ping 10.20.100.254  # Doit RÉUSSIR (management autorisé)
```

**Responsable :** @valorisa  
**Date de review :** Post-migration

---

### R04 — Perte de configuration des équipements

| Paramètre | Valeur |
|-----------|--------|
| **ID** | R04 |
| **Catégorie** | Configuration |
| **Probabilité** | 3 (Moyen) |
| **Impact** | 4 (Majeur) |
| **Score** | **12** (Élevé) |
| **Statut** | ✅ Mitigé |

**Description :**
Perte des configurations Fortigate/Cisco pendant la migration (erreur humaine, panne, etc.).

**Causes potentielles :**
- Oubli de sauvegarder avant modification
- Écran qui se déconnecte pendant la config
- Panne de courant pendant l'écriture

**Conséquences :**
- Temps de récupération prolongé
- Configuration perdue irrécupérable
- Erreurs de reconfiguration

**Mitigation :**
| Action | Type | Statut |
|--------|------|--------|
| Sauvegarder les configs avant toute modification | Préventif | ✅ Fait |
| Stocker les backups sur 3 supports différents | Préventif | ✅ Fait |
| Versionner les configs dans Git (ce repo) | Préventif | ✅ Fait |
| Avoir les configs imprimées en backup physique | Préventif | ⏳ À faire |

**Emplacement des backups :**
```
📁 C:\Users\bbrod\Projets\HomeLab VLAN Refactor Security\configs\
├── fortinet/
│   └── fg60f-backup-pre-migration.conf
└── cisco/
    └── catalyst-2960x-backup-pre-migration.conf

📁 Clé USB externe (backup physique)
📁 Cloud personnel (backup distant)
```

**Responsable :** @valorisa  
**Date de review :** Avant chaque modification

---

## 🟡 Risques Modérés (Score 5-9)

### R05 — DHCP scope épuisé pendant la migration

| Paramètre | Valeur |
|-----------|--------|
| **ID** | R05 |
| **Catégorie** | Disponibilité |
| **Probabilité** | 3 (Moyen) |
| **Impact** | 3 (Modéré) |
| **Score** | **9** (Modéré) |
| **Statut** | ✅ Mitigé |

**Description :**
La plage DHCP d'un VLAN est entièrement consommée, empêchant de nouveaux appareils de se connecter.

**Causes potentielles :**
- Plage DHCP trop petite (ex: .100-.150 = 50 adresses)
- Lease time trop long (adresses non libérées)
- Afflux d'appareils pendant la migration

**Conséquences :**
- Nouveaux appareils non routés
- Interruption de service pour certains utilisateurs
- Troubleshooting complexe

**Mitigation :**
| Action | Type | Statut |
|--------|------|--------|
| Réserver 20% d'adresses minimum (100 adresses par VLAN) | Préventif | ✅ Fait |
| Configurer des lease times adaptés (24h pour Admin, 7j pour IoT) | Préventif | ✅ Fait |
| Mettre en place des alertes de seuil (80% utilisé) | Détection | ⏳ À faire |
| Prévoir des plages extensibles | Préventif | ✅ Fait |

**Monitoring :**
```powershell
# Vérifier l'utilisation DHCP sur Windows Server
Get-DhcpServerv4ScopeStatistics | Select-Object ScopeId, Free, InUse, PercentageFree

# Alerter si < 20% libre
Get-DhcpServerv4ScopeStatistics | Where-Object { $_.PercentageFree -lt 20 } | Send-MailMessage -To "admin@domain.local"
```

**Responsable :** @valorisa  
**Date de review :** Mensuelle

---

### R06 — Conflit d'adresses IP

| Paramètre | Valeur |
|-----------|--------|
| **ID** | R06 |
| **Catégorie** | Configuration |
| **Probabilité** | 2 (Faible) |
| **Impact** | 4 (Majeur) |
| **Score** | **8** (Modéré) |
| **Statut** | ✅ Mitigé |

**Description :**
Deux appareils ont la même adresse IP, causant des conflits réseau.

**Causes potentielles :**
- IP statique dans la plage DHCP
- Deux DHCP servers actifs sur le même VLAN
- Erreur de documentation des réservations

**Conséquences :**
- Connectivité intermittente
- Troubleshooting complexe
- Perte de paquets

**Mitigation :**
| Action | Type | Statut |
|--------|------|--------|
| Documenter toutes les IP statiques dans `docs/02-vlan-table.md` | Préventif | ✅ Fait |
| Exclure les IP statiques des plages DHCP | Préventif | ✅ Fait |
| Désactiver tout DHCP server secondaire | Préventif | ✅ Fait |
| Scanner le réseau pour détecter les conflits | Détection | ⏳ À faire |

**Outil de détection :**
```powershell
# Scanner le réseau pour détecter les conflits IP
1..254 | ForEach-Object {
    $ip = "10.20.10.$_"
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        Write-Host "$ip - RÉPOND"
    }
}
```

**Responsable :** @valorisa  
**Date de review :** Avant migration

---

### R07 — Perte de connectivité WiFi pendant la migration

| Paramètre | Valeur |
|-----------|--------|
| **ID** | R07 |
| **Catégorie** | Disponibilité |
| **Probabilité** | 4 (Élevé) |
| **Impact** | 2 (Mineur) |
| **Score** | **8** (Modéré) |
| **Statut** | ⚠️ Accepté |

**Description :**
Les points d'accès WiFi perdent la connectivité pendant le reconfiguration VLAN.

**Causes potentielles :**
- Changement de VLAN sur les ports AP
- Controller UniFi inaccessible pendant la migration
- Mauvaise configuration des SSID/VLAN mappings

**Conséquences :**
- Perte de connectivité WiFi temporaire
- Utilisateurs mobiles impactés
- Support tickets potentiels

**Mitigation :**
| Action | Type | Statut |
|--------|------|--------|
| Planifier la migration WiFi en dernier (après filaire) | Préventif | ✅ Fait |
| Avoir un SSID de secours sur VLAN natif | Préventif | ⏳ À faire |
| Prévenir les utilisateurs à l'avance | Préventif | ✅ Fait |
| Tester tous les SSID post-migration | Détection | ✅ Planifié |

**Responsable :** @valorisa  
**Date de review :** Post-migration

---

## 🟢 Risques Faibles (Score 1-4)

### R08 — Documentation obsolète après migration

| Paramètre | Valeur |
|-----------|--------|
| **ID** | R08 |
| **Catégorie** | Documentation |
| **Probabilité** | 4 (Élevé) |
| **Impact** | 1 (Négligeable) |
| **Score** | **4** (Faible) |
| **Statut** | ✅ Accepté |

**Description :**
La documentation n'est pas mise à jour après les changements de configuration.

**Mitigation :**
- Mettre à jour ce repo Git après chaque changement
- Review trimestrielle de la documentation
- Versionner les configs dans `configs/`

**Responsable :** @valorisa

---

### R09 — Temps de récupération plus long que prévu

| Paramètre | Valeur |
|-----------|--------|
| **ID** | R09 |
| **Catégorie** | Disponibilité |
| **Probabilité** | 2 (Faible) |
| **Impact** | 2 (Mineur) |
| **Score** | **4** (Faible) |
| **Statut** | ✅ Accepté |

**Description :**
Le rollback ou la résolution d'incident prend plus de temps que prévu.

**Mitigation :**
- Chronométrer les procédures de rollback en lab
- Avoir les commandes critiques sous la main
- Documentation accessible hors-ligne (impression)

**Responsable :** @valorisa

---

## 📈 Matrice de risques visuelle

```
IMPACT
   5 │ R01 │    │    │    │
   4 │ R02 │ R03│ R04│    │
   3 │     │ R05│ R06│    │
   2 │     │    │ R07│    │
   1 │     │    │    │ R08│ R09
     └───┴────┴────┴────┴────┘
       1    2    3    4    5  PROBABILITÉ

🔴 17-25 : Critique    🟠 10-16 : Élevé
🟡 5-9   : Modéré      🟢 1-4  : Faible
```

---

## 🚨 Procédures d'urgence

### Contact et escalation

| Rôle | Personne | Contact | Disponibilité |
|------|----------|---------|---------------|
| **Admin réseau** | @valorisa | [À compléter] | 24/7 |
| **Support matériel** | [Fournisseur] | [À compléter] | 9h-18h |
| **Backup externe** | [Personne de confiance] | [À compléter] | Sur demande |

### Checklist d'urgence

```
[ ] 1. Identifier le symptôme principal
[ ] 2. Consulter la matrice des risques (ce document)
[ ] 3. Exécuter la procédure de mitigation associée
[ ] 4. Si échec → Exécuter le rollback complet
[ ] 5. Documenter l'incident dans ce fichier
[ ] 6. Review post-incident sous 48h
```

---

## 📊 Review post-incident

| Date | Incident | Cause racine | Action corrective | Statut |
|------|----------|--------------|-------------------|--------|
| [Date] | [Description] | [Cause] | [Action] | [Ouvert/Fermé] |

---

## 📚 Références

- ISO 31000:2018 — Risk Management Guidelines
- NIST SP 800-30 — Guide for Conducting Risk Assessments
- Fortinet Best Practices : https://docs.fortinet.com/
- Cisco Security Guidelines : https://www.cisco.com/c/en/us/security/

---
*Document généré automatiquement — Dernière mise à jour : 2026-03-30 13:45*  
*Prochaine review : 2026-03-30 13:45 + 3 mois*