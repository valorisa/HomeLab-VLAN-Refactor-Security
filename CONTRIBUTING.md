# Contribuer à HomeLab VLAN Refactor Security

Merci de l'intérêt que vous portez à ce projet ! Ce document fournit les lignes directrices pour contribuer.

---

## 📋 Table des matières

1. [Code de conduite](#-code-de-conduite)
2. [Comment contribuer](#-comment-contribuer)
3. [Workflow Git](#-workflow-git)
4. [Standards de code](#-standards-de-code)
5. [Documentation](#-documentation)
6. [Tests](#-tests)
7. [Soumission de PR](#-soumission-de-pr)
8. [Labels GitHub](#-labels-github)
9. [Questions fréquentes](#-questions-fréquentes)

---

## 🤝 Code de conduite

### Nos engagements

- **Respect** : Traiter tous les contributeurs avec respect et bienveillance
- **Inclusion** : Accueillir les contributeurs de tous niveaux et backgrounds
- **Collaboration** : Travailler ensemble pour améliorer le projet
- **Professionalisme** : Maintenir un ton professionnel dans les discussions

### Comportements attendus

- ✅ Utiliser un langage accueillant et inclusif
- ✅ Respecter les opinions et expériences différentes
- ✅ Accepter les critiques constructives avec grâce
- ✅ Se concentrer sur ce qui est meilleur pour la communauté

### Comportements inacceptables

- ❌ Commentaires sexualisés ou insultes
- ❌ Attaques personnelles ou politiques
- ❌ Harcèlement public ou privé
- ❌ Publication d'informations privées sans consentement

---

## 🚀 Comment contribuer

### Types de contributions

| Type | Description | Exemples |
|------|-------------|----------|
| 🐛 **Bug** | Signaler un problème | Erreur dans une config, lien brisé |
| ✨ **Feature** | Nouvelle fonctionnalité | Nouveau runbook, script d'automatisation |
| 📝 **Documentation** | Améliorer la docs | Correction typo, clarification, traduction |
| 🔧 **Config** | Configuration matériel | Ajout support nouveau matériel |
| 🧪 **Testing** | Tests et validation | Procédure de test, checklist |
| 🔒 **Security** | Sécurité | Vulnérabilité, best practice |

### Processus de contribution

```text
1. Fork le projet (optionnel pour contributeurs externes)
2. Créer une branche feature (git checkout -b feature/ma-feature)
3. Faire les changements
4. Tester les changements
5. Commiter (git commit -m "type: description")
6. Pousser (git push origin feature/ma-feature)
7. Ouvrir une Pull Request
```

---

## 🌿 Workflow Git

### Branches

| Branche | Usage | Protection |
|---------|-------|------------|
| `main` | Version stable, production | ✅ Protégée (PR requise) |
| `dev` | Développement quotidien | ⚠️ Non protégée |
| `feature/*` | Nouvelles fonctionnalités | — |
| `fix/*` | Corrections de bugs | — |
| `docs/*` | Documentation | — |

### Convention de nommage des branches

```text
feature/ajout-runbook-backup
fix/correction-syntaxe-mermaid
docs/mise-a-jour-architecture
config/fortigate-nouvelle-version
```

### Messages de commit (Conventional Commits)

**Format :** `type: description courte`

| Type | Usage | Exemple |
|------|-------|---------|
| `feat` | Nouvelle fonctionnalité | `feat: ajout script backup automatique` |
| `fix` | Correction de bug | `fix: correction syntaxe Mermaid` |
| `docs` | Documentation | `docs: mise à jour README` |
| `config` | Configuration | `config: ajout VLAN 300` |
| `test` | Tests | `test: ajout tests connectivité VLAN` |
| `refactor` | Refactoring | `refactor: réorganisation dossiers configs` |
| `chore` | Tâches diverses | `chore: mise à jour dépendances` |

**Exemples de commits :**

```bash
# Simple
git commit -m "docs: ajout CONTRIBUTING.md"

# Détaillé (multi-lignes)
git commit -m "feat: ajout runbook backup automatique

- Script PowerShell pour backup Fortigate
- Planification via Task Scheduler
- Notification email après backup
- Rotation des backups (7 jours)"
```

---

## 📝 Standards de code

### Configurations Fortinet/Cisco

```fortinet
# ✅ BON : Commentaires clairs, indentation cohérente
config system interface
    edit "vlan10"
        set ip 10.20.10.254 255.255.255.0
        set description "VLAN-Admin"
    next
end
```

```cisco
! ✅ BON : Commentaires avec !, indentation 1 espace
interface Vlan10
 description Management-Switch
 ip address 10.20.10.2 255.255.255.0
 no shutdown
exit
```

### Scripts PowerShell

```powershell
# ✅ BON : Verb-Approuvé, commentaires, gestion d'erreur
function Test-VLANConnectivity {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$VlanId
    )
    
    try {
        # Test de connectivité
        Test-Connection -ComputerName "10.20.$VlanId.254" -Count 2
    }
    catch {
        Write-Error "Échec test VLAN $VlanId : $_"
    }
}
```

### Documentation Markdown

```markdown
# ✅ BON : Titres hiérarchisés, listes, tableaux

## Section principale

### Sous-section

- Liste à puces
- Avec plusieurs items

| Colonne 1 | Colonne 2 |
|-----------|-----------|
| Valeur 1  | Valeur 2  |
```

---

## 📚 Documentation

### Fichiers de documentation

| Fichier | Usage |
|---------|-------|
| `README.md` | Vue d'ensemble du projet |
| `CHANGELOG.md` | Historique des versions |
| `CONTRIBUTING.md` | Guide de contribution |
| `docs/01-architecture.md` | Architecture cible |
| `docs/02-vlan-table.md` | Tableau des VLAN |
| `docs/03-risk-matrix.md` | Matrice des risques |
| `runbooks/*.md` | Procédures opérationnelles |

### Standards de documentation

- ✅ **Clarté** : Phrases courtes, vocabulaire technique expliqué
- ✅ **Exemples** : Commandes CLI copiables directement
- ✅ **Checklists** : Étapes validables une par une
- ✅ **Screenshots** : Quand pertinent (interfaces GUI)
- ✅ **Liens** : Références vers documentation officielle

---

## 🧪 Tests

### Tests requis avant PR

| Type de changement | Tests requis |
|-------------------|--------------|
| Configuration | Test en lab isolé |
| Script | Exécution test + validation sortie |
| Documentation | Relecture + validation liens |
| Runbook | Simulation procédure |

### Checklist de test

```text
[ ] Syntaxe validée (Fortinet/Cisco/PowerShell)
[ ] Tests exécutés en lab
[ ] Rollback testé
[ ] Documentation mise à jour
[ ] CHANGELOG mis à jour (si applicable)
```

---

## 📤 Soumission de PR

### Template de Pull Request

```markdown
## 📋 Description

[Description courte du changement]

## 🎯 Type de changement

- [ ] 🐛 Bug fix
- [ ] ✨ Nouvelle fonctionnalité
- [ ] 📝 Documentation
- [ ] 🔧 Configuration
- [ ] 🧪 Tests
- [ ] 🔒 Sécurité

## 📄 Fichiers concernés

- [Liste des fichiers modifiés]

## 🧪 Tests effectués

- [ ] Tests en lab
- [ ] Documentation validée
- [ ] Rollback testé

## 📚 Références

[Liens vers issues, documentation, etc.]
```

### Critères de review

| Critère | Requis |
|---------|--------|
| Message de commit clair | ✅ |
| Tests passés | ✅ |
| Documentation mise à jour | ✅ |
| Labels appliqués | ✅ |
| CHANGELOG mis à jour (si version) | ✅ |

---

## 🏷️ Labels GitHub

### Labels disponibles

| Label | Couleur | Usage |
|-------|---------|-------|
| `bug` | 🔴 | Quelque chose ne fonctionne pas |
| `documentation` | 🔵 | Améliorations documentation |
| `enhancement` | 🔷 | Nouvelle fonctionnalité |
| `help wanted` | 🟢 | Recherche contributeurs |
| `question` | 🟣 | Demande d'information |
| `configuration` | 🟡 | Changements de config |
| `security` | 🟠 | Problèmes sécurité |
| `migration` | 🔵 | Tâches migration VLAN |
| `fortinet` | 🔴 | Config Fortinet |
| `cisco` | 🔷 | Config Cisco |
| `wifi` | 🟡 | Config WiFi/UniFi |
| `testing` | 🔴 | Tests et validation |
| `deployment` | ⚫ | Déploiement production |

### Comment utiliser les labels

- **Auto-appliqués** : Les mainteneurs appliquent les labels lors de la review
- **Suggestion** : Les contributeurs peuvent suggérer des labels dans la PR
- **Recherche** : Utiliser les labels pour filtrer les PR/issues

---

## ❓ Questions fréquentes

### Q: Comment signaler un bug ?

**R:** Ouvrir une **Issue** avec le label `bug` et inclure :
- Description du problème
- Étapes pour reproduire
- Comportement attendu vs observé
- Logs/screenshots si pertinent

### Q: Comment proposer une nouvelle fonctionnalité ?

**R:** Ouvrir une **Issue** avec le label `enhancement` et décrire :
- Le besoin/utilité
- La solution proposée
- Les alternatives considérées

### Q: Combien de temps pour une review de PR ?

**R:** Typiquement **24-48h** pour les PR simples, **3-5 jours** pour les changements majeurs.

### Q: Puis-je contribuer sans être expert réseau ?

**R:** **Oui !** Les contributions documentation, tests, et même questions sont les bienvenues.

---

## 📞 Contacts

| Rôle | Contact |
|------|---------|
| Mainteneur principal | @valorisa |
| Issues GitHub | https://github.com/valorisa/HomeLab-VLAN-Refactor-Security/issues |
| Discussions | https://github.com/valorisa/HomeLab-VLAN-Refactor-Security/discussions |

---

## 📚 Références

| Document | Lien |
|----------|------|
| Conventional Commits | https://www.conventionalcommits.org/fr/ |
| Keep a Changelog | https://keepachangelog.com/fr/1.0.0/ |
| GitHub Flow | https://docs.github.com/fr/get-started/using-github/github-flow |
| Code de conduite Contributor Covenant | https://www.contributor-covenant.org/fr/ |

---

*Merci de contribuer à HomeLab VLAN Refactor Security !* 🎉