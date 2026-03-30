# Changelog

Tous les changements notables dans ce projet seront documentés dans ce fichier.

Ce fichier suit le format [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/)
et ce projet adhère au [Semantic Versioning](https://semver.org/lang/fr/).

---

## [Non publié]

### 📋 À faire
- [ ] Compléter les adresses MAC réelles dans les configs Fortinet/Cisco
- [ ] Tester les configurations en lab isolé
- [ ] Planifier la fenêtre de migration (week-end)
- [ ] Exécuter la migration VLAN selon le runbook
- [ ] Déployer la segmentation WiFi PPSK

---

## [1.2.0] - 2026-03-30

### ✨ Ajouté

#### Documentation
- `runbooks/03-wifi-ppsk.md` — Déploiement WiFi avec segmentation PPSK
  - Configuration UniFi Controller
  - 3 SSID (Admin, PC, IoT) avec VLAN tagging
  - Gestion sécurisée des mots de passe
  - Procédure de rollback

- `runbooks/02-vlan-migration.md` — Procédure de migration VLAN
  - 8 phases détaillées (22:00-06:00)
  - Migration par type d'équipement
  - Procédure de rollback complète
  - Checklists de validation

#### Configurations
- `configs/fortinet/fg60f-lag-base.conf` — Configuration Fortigate 60F
  - LAG (port3 + port4) avec LACP actif
  - 6 interfaces VLAN (10, 50, 99, 100, 200, 1000)
  - 7 politiques firewall inter-VLAN
  - DHCP server avec 5 scopes
  - Réservations DHCP (template)
  - Sécurité renforcée

- `configs/cisco/catalyst-2960x-lag.conf` — Configuration Cisco 2960X
  - Port-Channel 1 avec LACP
  - 6 VLAN configurés
  - QoS pour VoIP (DSCP mapping)
  - Sécurité des ports (BPDU guard)
  - SNMP monitoring

### 📝 Modifié
- PR #7 — Ajout des configurations et runbooks de migration

---

## [1.1.0] - 2026-03-30

### ✨ Ajouté

#### Documentation
- `docs/03-risk-matrix.md` — Matrice complète des risques
  - 9 risques identifiés et évalués (ISO 31000)
  - Procédures de mitigation et rollback
  - Matrice visuelle Impact/Probabilité
  - Checklist d'urgence

- `runbooks/01-lag-fortinet-cisco.md` — Procédure LAG
  - Configuration Fortigate 60F étape par étape
  - Configuration Cisco 2960X détaillée
  - Tests de validation et failover
  - Procédure de rollback documentée

### 📝 Modifié
- PR #6 — Ajout risk matrix + LAG runbook

---

## [1.0.3] - 2026-03-30

### 🐛 Corrigé
- `docs/01-architecture.md` — Correction syntaxe Mermaid
  - Diagramme "Flux de données critiques" maintenant fonctionnel
  - Labels Mermaid correctement formatés

### 📝 Modifié
- PR #2 — Correction syntaxe Mermaid dans architecture.md

---

## [1.0.2] - 2026-03-30

### ✨ Ajouté
- `docs/02-vlan-table.md` — Tableau complet des VLAN
  - 6 VLAN détaillés (Admin, PC, Native, IoT, VoIP, Merdouille)
  - Matrice de sécurité inter-VLAN
  - Règles firewall Fortigate
  - Configuration QoS pour VoIP
  - Réservations DHCP statiques

### 📝 Modifié
- PR #3 — Ajout VLAN table documentation

---

## [1.0.1] - 2026-03-30

### ✨ Ajouté
- `docs/WIP.md` — Indicateur de travail en cours
- Branche `dev` pour le développement quotidien
- PR draft pour suivre l'avancement

### 📝 Modifié
- PR #1 — Setup initial du projet

---

## [1.0.0] - 2026-03-30

### ✨ Ajouté

#### Structure du projet
- `README.md` — Description et objectifs du projet
- `docs/` — Documentation technique
  - `01-architecture.md` — Architecture cible avec diagrammes Mermaid
- `configs/` — Configurations matérielles
  - `cisco/.gitkeep`
  - `fortinet/.gitkeep`
- `runbooks/` — Procédures opérationnelles
  - `.gitkeep`
- `scripts/` — Scripts d'automatisation
  - `rsync-qnap.sh` — Synchronisation NAS
  - `qnap-shutdown.sh` — Extinction QNAP
- `hardware/` — Documentation matériel
  - `budget-occasion-1000e.md`
- `diagrams/` — Diagrammes et schémas
  - `architecture-mermaid.md`

#### Infrastructure GitHub
- 16 topics GitHub pour la visibilité
- Branche `main` protégée (PR requises)
- Workflow PR avec reviews

### 🎯 Objectifs du projet
- Segmentation réseau (Admin, PC, IoT, VoIP, Transition)
- Haute disponibilité (LAG Fortinet ↔ Cisco)
- Performance (Backhaul 10 Gb/s)
- Sécurité (Politiques firewall granulaires)
- Budget maîtrisé (≤ 1000€ matériel occasion)

---

## Légende

### Types de changements

| Icône | Type | Description |
|-------|------|-------------|
| ✨ | Ajouté | Nouvelles fonctionnalités |
| 🐛 | Corrigé | Corrections de bugs |
| 📝 | Modifié | Modifications de documentation |
| 🔧 | Technique | Changements de configuration |
| 🗑️ | Supprimé | Fonctionnalités supprimées |
| 🔒 | Sécurité | Changements liés à la sécurité |
| 🚀 | Performance | Améliorations de performance |

### Niveaux de version (Semantic Versioning)

| Type | Format | Quand l'utiliser |
|------|--------|------------------|
| **Majeur** | X.0.0 | Changements incompatibles avec la version précédente |
| **Mineur** | 1.X.0 | Nouvelles fonctionnalités rétrocompatibles |
| **Patch** | 1.0.X | Corrections de bugs rétrocompatibles |

---

## 📚 Références

- [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/)
- [Semantic Versioning](https://semver.org/lang/fr/)
- [GitHub Changelog Guidelines](https://docs.github.com/fr/repositories/releasing-projects-on-github/automatically-generated-release-notes)

---

*Document généré automatiquement — 2026-03-30*