# Runbook : Déploiement WiFi PPSK

> Configuration UniFi avec segmentation par mot de passe (Private Pre-Shared Key)

---

## 📋 Informations générales

| Paramètre | Valeur |
|-----------|--------|
| **ID Runbook** | RB-003 |
| **Titre** | Déploiement WiFi PPSK |
| **Version** | 1.0 |
| **Auteur** | @valorisa |
| **Temps estimé** | 2 heures |
| **Niveau de risque** | 🟡 Modéré (impact WiFi uniquement) |

---

## 🎯 Objectifs

- [ ] Configurer UniFi Controller avec PPSK
- [ ] Créer 3 SSID (Admin, PC, IoT)
- [ ] Associer chaque PPSK à un VLAN
- [ ] Tester la segmentation

---

## 📐 Prérequis

| SSID | VLAN | PPSK | Usage |
|------|------|------|-------|
| SSID-5G-Admin | 10 | `Admin@HomeLab2026!` | Admin, NAS, Server |
| SSID-5G-PC | 50 | `PC@HomeLab2026!` | PC utilisateurs |
| SSID-2.4-IoT | 100 | `IoT@HomeLab2026!` | Objets connectés |

---

## 🔧 Procédure de configuration

### Étape 1 : Configuration UniFi Controller (30 min)

```bash
# Settings → Networks → Create New
# Réseau Admin (VLAN 10)
# Réseau PC (VLAN 50)
# Réseau IoT (VLAN 100)
```

### Étape 2 : Configuration des SSID (30 min)

```bash
# Settings → WiFi → Create New
# SSID-5G-Admin → VLAN 10
# SSID-5G-PC → VLAN 50
# SSID-2.4-IoT → VLAN 100
```

### Étape 3 : Tests de validation (30 min)

```bash
# Se connecter avec chaque PPSK
# Vérifier l'IP reçue (doit correspondre au VLAN)
# Tester la segmentation (IoT ne doit pas ping Admin)
```

---

## 🧪 Checklist de validation

### Tests de connectivité

- [ ] SSID-5G-Admin → IP en 10.20.10.x
- [ ] SSID-5G-PC → IP en 10.20.50.x
- [ ] SSID-2.4-IoT → IP en 10.20.100.x
- [ ] Internet fonctionnel sur tous les SSID
- [ ] Isolation IoT vérifiée

---

## 🔐 Gestion des mots de passe

### Stockage sécurisé

```
📁 Bitwarden / KeePass
├── WiFi-Admin : Admin@HomeLab2026!
├── WiFi-PC : PC@HomeLab2026!
└── WiFi-IoT : IoT@HomeLab2026!
```

### Rotation des mots de passe

| Fréquence | Action |
|-----------|--------|
| Tous les 6 mois | Changer tous les PPSK |
| Après incident sécurité | Changer tous les PPSK |

---

*Document généré automatiquement*