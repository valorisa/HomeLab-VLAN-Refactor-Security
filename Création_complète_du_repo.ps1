# ═══════════════════════════════════════════════════════════════
# 0. CONFIGURATION
# ═══════════════════════════════════════════════════════════════
$owner = "valorisa"
$repoName = "HomeLab-VLAN-Refactor-Security"  # Nom GitHub (avec tirets)
$localPath = "C:\Users\bbrod\Projets\HomeLab VLAN Refactor Security"
$description = "Refonte complète d'infrastructure HomeLab : migration VLAN, sécurité, matériel occasion ≤1000€. Inspiré du projet iMot3k."

# ═══════════════════════════════════════════════════════════════
# 1. CRÉER UN .gitignore ADAPTÉ (optionnel mais recommandé)
# ═══════════════════════════════════════════════════════════════
$gitignore = @'
# Fortinet / Cisco configs sensibles
*.key
*.pem
*.crt
*password*
*secret*

# Logs et fichiers temporaires
*.log
*.tmp
*.bak
.DS_Store
Thumbs.db

# IDE / Éditeurs
.vscode/
.idea/
*.swp
*.swo

# Scripts générés
*.generated.*

# Environnements virtuels
venv/
.venv/
__pycache__/
'@
$gitignore | Out-File -FilePath "$localPath\.gitignore" -Encoding utf8 -NoNewline
Write-Host "✓ .gitignore créé" -ForegroundColor Cyan

# ═══════════════════════════════════════════════════════════════
# 2. INITIALISER LE DÉPÔT GIT LOCAL
# ═══════════════════════════════════════════════════════════════
Set-Location $localPath

# Initialiser Git avec la branche 'main' par défaut
git init -b main

# Ajouter tous les fichiers (sauf ceux du .gitignore)
git add .

# Premier commit
git commit -m "feat: initial commit - HomeLab VLAN Refactor documentation

- Architecture cible VLAN (Admin, PC, IoT, VoIP, Merdouille)
- Matériel occasion ≤1000€ (Fortigate, Cisco, MikroTik, Ubiquiti)
- Playbooks de migration et runbooks opérationnels
- Configurations CLI Fortinet/Cisco + scripts Bash
- Matrice des risques et procédures de rollback

Source: projet iMot3k (YouTube)"

Write-Host "✓ Dépôt Git local initialisé sur branche 'main'" -ForegroundColor Cyan

# ═══════════════════════════════════════════════════════════════
# 3. CRÉER LE DÉPÔT SUR GITHUB VIA gh CLI
# ═══════════════════════════════════════════════════════════════
# Créer le repo distant (privé par défaut, changez --public si besoin)
gh repo create "$owner/$repoName" `
    --description $description `
    --private `
    --source "$localPath" `
    --push `
    --remote upstream

Write-Host "✓ Dépôt GitHub créé : https://github.com/$owner/$repoName" -ForegroundColor Green

# ═══════════════════════════════════════════════════════════════
# 4. CONFIGURER LE REMOTE 'origin' (nom conventionnel)
# ═══════════════════════════════════════════════════════════════
# Renommer 'upstream' en 'origin' (convention Git standard)
git remote rename upstream origin

# Vérifier la configuration
git remote -v

Write-Host "✓ Remote 'origin' configuré" -ForegroundColor Cyan

# ═══════════════════════════════════════════════════════════════
# 5. VÉRIFICATION FINALE
# ═══════════════════════════════════════════════════════════════
Write-Host "`n🎉 RÉCAPITULATIF :" -ForegroundColor Green
Write-Host "  • Dépôt local : $localPath" -ForegroundColor White
Write-Host "  • Branche : main" -ForegroundColor White
Write-Host "  • Remote : origin => https://github.com/$owner/$repoName.git" -ForegroundColor White
Write-Host "  • Fichiers poussés : $(git rev-list --count HEAD) commit(s)" -ForegroundColor White
Write-Host "`n🔗 Accéder au dépôt : https://github.com/$owner/$repoName" -ForegroundColor Yellow
