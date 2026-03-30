# Runbook : Migration VLAN 1 → VLAN 1000

> Procédure de migration progressive des équipements du VLAN 1 (défaut) vers les nouveaux VLAN segmentés

---

## 📋 Informations générales

| Paramètre | Valeur |
|-----------|--------|
| **ID Runbook** | RB-002 |
| **Titre** | Migration VLAN 1 → VLAN 1000 |
| **Version** | 1.0 |
| **Auteur** | @valorisa |
| **Temps estimé** | 4-6 heures (fenêtre de maintenance) |
| **Niveau de risque** | 🔴 Critique (impact réseau majeur) |
| **Fenêtre de maintenance** | 22:00 - 06:00 (week-end recommandé) |

---

## 🎯 Objectifs

- [ ] Migrer tous les équipements du VLAN 1 vers les VLAN cibles
- [ ] Assurer une transition sans interruption de service
- [ ] Valider chaque étape avant de poursuivre
- [ ] Avoir un rollback prêt à chaque phase

---

## 📊 Phases de migration

```
Phase 1 (22:00-23:00) : Infrastructure critique (Fortigate, Cisco, Server)
Phase 2 (23:00-00:00) : Serveurs et NAS (Proxmox, TrueNAS, QNAP)
Phase 3 (00:00-01:00) : PC Admin et postes principaux
Phase 4 (01:00-02:00) : WiFi et points d'accès
Phase 5 (02:00-03:00) : IoT et appareils connectés
Phase 6 (03:00-04:00) : VoIP et téléphones
Phase 7 (04:00-05:00) : Tests et validation globale
Phase 8 (05:00-06:00) : Buffer et rollback si besoin
```

---

## 🔧 Phase 1 : Infrastructure critique (22:00-23:00)

### 1.1 Migration du Fortigate

```fortinet
config system interface
    edit "lag1"
        set ip 10.20.10.1 255.255.255.0
    next
    edit "vlan10"
        set ip 10.20.10.254 255.255.255.0
    next
end
```

**Validation :**
- [ ] Fortigate accessible sur 10.20.10.1
- [ ] Interface lag1 UP
- [ ] Interface vlan10 UP

### 1.2 Migration du Cisco

```cisco
configure terminal
vlan 10,50,99,100,200,1000
exit

interface Vlan10
 ip address 10.20.10.2 255.255.255.0
 no shutdown
exit
```

**Validation :**
- [ ] Cisco accessible sur 10.20.10.2
- [ ] Tous les VLAN créés
- [ ] Port-Channel UP

---

## 🚨 Procédure de rollback

### Si problèmes majeurs

```bash
# FORTIGATE - Rollback
execute restore config flash "fg60f-backup-PRE-migration.conf"
execute reboot

# CISCO - Rollback
copy flash:catalyst-2960x-backup-PRE-migration.conf running-config
write memory
reload
```

### Timeline de décision

| Heure | Décision |
|-------|----------|
| 05:00 | Si problèmes mineurs → Continuer troubleshooting |
| 05:30 | Si problèmes majeurs → Initier rollback |
| 06:00 | Rollback doit être complété |

---

## 📝 Checklist finale

### Avant clôture

- [ ] Tous les équipements migrés
- [ ] Tous les tests passés
- [ ] Aucun ticket support ouvert
- [ ] Backups post-migration effectués
- [ ] Documentation mise à jour

---

*Document généré automatiquement*