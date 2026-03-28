# ═══════════════════════════════════════════════════════════════
# CRÉER L'ARBORESCENCE COMPLÈTE - HomeLab VLAN Refactor Security
# Version corrigée avec gestion des permissions Git
# ═══════════════════════════════════════════════════════════════

$projectRoot = "C:\Users\bbrod\Projets\HomeLab VLAN Refactor Security"
Set-Location $projectRoot

# ═══════════════════════════════════════════════════════════════
# 1. CRÉER LES DOSSIERS
# ═══════════════════════════════════════════════════════════════
$dirs = @(
    "docs",
    "hardware",
    "runbooks",
    "configs/fortinet",
    "configs/cisco",
    "scripts",
    "diagrams"
)
foreach ($dir in $dirs) {
    New-Item -Path $dir -ItemType Directory -Force | Out-Null
    Write-Host "✓ Créé : $dir" -ForegroundColor Cyan
}

# ═══════════════════════════════════════════════════════════════
# 2. FONCTION POUR CRÉER UN FICHIER MARKDOWN
# ═══════════════════════════════════════════════════════════════
function New-MarkdownFile {
    param([string]$Path, [string]$Title, [string]$Description)
    $content = @"
# $Title

> $Description

---

## 📋 Sommaire
- [ ] Section 1
- [ ] Section 2
- [ ] À compléter...

---
*Document généré automatiquement — À compléter*
"@
    $content | Out-File -FilePath $Path -Encoding utf8 -NoNewline
    Write-Host "✓ Créé : $Path" -ForegroundColor Green
}

# ═══════════════════════════════════════════════════════════════
# 3. FONCTION POUR CRÉER UN FICHIER DE CONFIGURATION
# ═══════════════════════════════════════════════════════════════
function New-ConfigFile {
    param([string]$Path, [string]$Comment)
    $content = @"
# $Comment
# Fichier généré automatiquement — À compléter

"@
    $content | Out-File -FilePath $Path -Encoding utf8 -NoNewline
    Write-Host "✓ Créé : $Path" -ForegroundColor Green
}

# ═══════════════════════════════════════════════════════════════
# 4. FONCTION POUR CRÉER UN SCRIPT BASH
# ═══════════════════════════════════════════════════════════════
function New-BashScript {
    param([string]$Path, [string]$Description)
    $content = @"
#!/bin/bash
# $Description
# Fichier généré automatiquement — À compléter

set -euo pipefail

echo "[$(date)] Script démarré"

# TODO: Ajouter la logique ici

echo "[$(date)] Script terminé"
"@
    $content | Out-File -FilePath $Path -Encoding utf8 -NoNewline
    Write-Host "✓ Créé : $Path" -ForegroundColor Green
}

# ═══════════════════════════════════════════════════════════════
# 5. CRÉER LES FICHIERS docs/
# ═══════════════════════════════════════════════════════════════
New-MarkdownFile "docs/01-architecture.md" "Architecture cible" "Diagrammes et schémas de l'infrastructure VLAN"
New-MarkdownFile "docs/02-vlan-table.md" "Tableau des VLAN" "Référentiel des VLAN, sous-réseaux et règles de sécurité"
New-MarkdownFile "docs/03-risk-matrix.md" "Matrice des risques" "Identification, impact et procédures de rollback"

# ═══════════════════════════════════════════════════════════════
# 6. CRÉER LES FICHIERS hardware/
# ═══════════════════════════════════════════════════════════════
New-MarkdownFile "hardware/budget-occasion-1000e.md" "Budget matériel occasion ≤1000€" "Comparatif, liens d'achat et justifications des choix"

# ═══════════════════════════════════════════════════════════════
# 7. CRÉER LES RUNBOOKS/
# ═══════════════════════════════════════════════════════════════
New-MarkdownFile "runbooks/01-lag-fortinet-cisco.md" "Runbook : LAG Fortinet ↔ Cisco" "Procédure pas-à-pas pour configurer le LACP"
New-MarkdownFile "runbooks/02-vlan-migration.md" "Runbook : Migration VLAN 1 → VLAN 1000" "Migration progressive sans interruption de service"
New-MarkdownFile "runbooks/03-wifi-ppsk.md" "Runbook : Déploiement WiFi PPSK" "Configuration UniFi avec segmentation par mot de passe"

# ═══════════════════════════════════════════════════════════════
# 8. CRÉER LES CONFIGS/
# ═══════════════════════════════════════════════════════════════
New-ConfigFile "configs/fortinet/fg60f-lag-base.conf" "Configuration Fortigate 60F - LAG + VLAN de base"
New-ConfigFile "configs/cisco/catalyst-2960x-lag.conf" "Configuration Cisco Catalyst 2960X - LACP + Trunk"

# ═══════════════════════════════════════════════════════════════
# 9. CRÉER LES SCRIPTS/ (AVEC GESTION DES PERMISSIONS GIT)
# ═══════════════════════════════════════════════════════════════
New-BashScript "scripts/rsync-qnap.sh" "Synchronisation TrueNAS → QNAP via Rsync 10Gb/s"
New-BashScript "scripts/qnap-shutdown.sh" "Shutdown automatique du QNAP après backup"

# ✅ CORRECTION : Ajouter les scripts à l'index AVANT de changer les permissions
git add scripts/rsync-qnap.sh scripts/qnap-shutdown.sh

# ✅ Rendre les scripts exécutables dans Git (pour WSL/Linux)
git update-index --chmod=+x scripts/rsync-qnap.sh
git update-index --chmod=+x scripts/qnap-shutdown.sh

Write-Host "✅ Permissions des scripts corrigées" -ForegroundColor Green

# ═══════════════════════════════════════════════════════════════
# 10. CRÉER LES DIAGRAMS/
# ═══════════════════════════════════════════════════════════════
New-MarkdownFile "diagrams/architecture-mermaid.md" "Diagramme d'architecture (Mermaid)" "Code Mermaid pour générer le schéma réseau"

# ═══════════════════════════════════════════════════════════════
# 11. CRÉER LES .gitkeep DANS CHAQUE DOSSIER
# ═══════════════════════════════════════════════════════════════
foreach ($dir in $dirs) {
    $gitkeep = Join-Path $dir ".gitkeep"
    if (-not (Test-Path $gitkeep)) {
        "# Keep this directory in Git" | Out-File -FilePath $gitkeep -Encoding utf8
    }
}

# ═══════════════════════════════════════════════════════════════
# 12. COMMIT ET PUSH VERS GITHUB
# ═══════════════════════════════════════════════════════════════
Write-Host "`n📦 Préparation du commit..." -ForegroundColor Cyan

# Ajouter tous les fichiers restants
git add .

# Vérifier ce qui va être commité
Write-Host "`n📋 Fichiers à commiter :" -ForegroundColor Yellow
git status --short

# Commit structuré
git commit -m "feat: create complete project structure

- docs/ : Architecture, VLAN table, risk matrix
- hardware/ : Budget matériel occasion ≤1000€
- runbooks/ : Procédures LAG, migration VLAN, WiFi PPSK
- configs/ : Templates Fortinet (fg60f) et Cisco (2960x)
- scripts/ : Rsync QNAP + shutdown auto (exécutables +x)
- diagrams/ : Schéma Mermaid

Structure conforme au README.md"

# Pousser vers GitHub
git push origin main

# ═══════════════════════════════════════════════════════════════
# 13. VÉRIFICATION FINALE
# ═══════════════════════════════════════════════════════════════
Write-Host "`n🎉 ARBORESCENCE CRÉÉE AVEC SUCCÈS !" -ForegroundColor Green
Write-Host "  • Dépôt local : $projectRoot" -ForegroundColor White
Write-Host "  • Remote : origin → https://github.com/valorisa/HomeLab-VLAN-Refactor-Security" -ForegroundColor White
Write-Host "  • Branche : main" -ForegroundColor White

# Ouvrir le dépôt dans le navigateur
Write-Host "`n🔗 Ouverture du dépôt GitHub..." -ForegroundColor Cyan
start "https://github.com/valorisa/HomeLab-VLAN-Refactor-Security"

# Vérifier les permissions des scripts dans Git
Write-Host "`n📄 Permissions des scripts :" -ForegroundColor Yellow
git ls-files --stage scripts/
