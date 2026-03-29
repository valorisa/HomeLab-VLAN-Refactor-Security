# ═══════════════════════════════════════════════════════════════
# VÉRIFICATION DE SYNCHRONISATION - Avant pause
# ═══════════════════════════════════════════════════════════════

Set-Location "C:\Users\bbrod\Projets\HomeLab VLAN Refactor Security"

Write-Host "`n═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  📊 ÉTAT DE SYNCHRONISATION - HomeLab VLAN Refactor" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

# ───────────────────────────────────────────────────────────────────
# 1. VÉRIFIER LE WORKING TREE (aucun fichier modifié non commité)
# ───────────────────────────────────────────────────────────────────
Write-Host "1️⃣  Working Tree (fichiers modifiés non commités) :" -ForegroundColor Yellow
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "   ⚠️  ATTENTION : Fichiers en attente :" -ForegroundColor Red
    git status --short
} else {
    Write-Host "   ✅ PROPRE : Aucun fichier modifié en attente" -ForegroundColor Green
}

# ───────────────────────────────────────────────────────────────────
# 2. VÉRIFIER LA BRANCHE ACTUELLE
# ───────────────────────────────────────────────────────────────────
Write-Host "`n2️⃣  Branche actuelle :" -ForegroundColor Yellow
$currentBranch = git branch --show-current
Write-Host "   📍 $currentBranch" -ForegroundColor White

# ───────────────────────────────────────────────────────────────────
# 3. VÉRIFIER LA BRANCHE 'main' (locale vs distante)
# ───────────────────────────────────────────────────────────────────
Write-Host "`n3️⃣  Branche 'main' (locale vs origin/main) :" -ForegroundColor Yellow
git checkout main --quiet
$mainStatus = git status --branch --porcelain
if ($mainStatus -match "ahead") {
    Write-Host "   ⚠️  main locale est EN AVANT de origin/main" -ForegroundColor Red
    git status --short --branch
} elseif ($mainStatus -match "behind") {
    Write-Host "   ⚠️  main locale est EN RETARD de origin/main" -ForegroundColor Red
    git status --short --branch
} else {
    Write-Host "   ✅ SYNCHRONISÉE : main locale = origin/main" -ForegroundColor Green
}

# ───────────────────────────────────────────────────────────────────
# 4. VÉRIFIER LA BRANCHE 'dev' (locale vs distante)
# ───────────────────────────────────────────────────────────────────
Write-Host "`n4️⃣  Branche 'dev' (locale vs origin/dev) :" -ForegroundColor Yellow
git checkout dev --quiet
$devStatus = git status --branch --porcelain
if ($devStatus -match "ahead") {
    Write-Host "   ⚠️  dev locale est EN AVANT de origin/dev" -ForegroundColor Red
    git status --short --branch
} elseif ($devStatus -match "behind") {
    Write-Host "   ⚠️  dev locale est EN RETARD de origin/dev" -ForegroundColor Red
    git status --short --branch
} else {
    Write-Host "   ✅ SYNCHRONISÉE : dev locale = origin/dev" -ForegroundColor Green
}

# ───────────────────────────────────────────────────────────────────
# 5. COMPARER main ET dev (même commit ?)
# ───────────────────────────────────────────────────────────────────
Write-Host "`n5️⃣  Comparaison main vs dev :" -ForegroundColor Yellow
$mainCommit = git rev-parse main
$devCommit = git rev-parse dev
if ($mainCommit -eq $devCommit) {
    Write-Host "   ⚠️  main et dev pointent vers le MÊME commit" -ForegroundColor Yellow
    Write-Host "      💡 C'est normal après un merge, mais dev devrait diverger pour le prochain travail" -ForegroundColor Gray
} else {
    Write-Host "   ✅ DIFFÉRENTS : main et dev sont sur des commits différents" -ForegroundColor Green
    Write-Host "      main : $mainCommit" -ForegroundColor Gray
    Write-Host "      dev  : $devCommit" -ForegroundColor Gray
}

# ───────────────────────────────────────────────────────────────────
# 6. DERNIERS COMMITS (historique récent)
# ───────────────────────────────────────────────────────────────────
Write-Host "`n6️⃣  3 derniers commits sur main :" -ForegroundColor Yellow
git log --oneline -3 --graph

# ───────────────────────────────────────────────────────────────────
# 7. ÉTAT DES PR GITHUB
# ───────────────────────────────────────────────────────────────────
Write-Host "`n7️⃣  Pull Requests ouvertes :" -ForegroundColor Yellow
$openPRs = gh pr list --state open --json number,title,headRefName | ConvertFrom-Json
if ($openPRs) {
    foreach ($pr in $openPRs) {
        Write-Host "   🔵 PR #$($pr.number) : $($pr.title) (branche: $($pr.headRefName))" -ForegroundColor Cyan
    }
} else {
    Write-Host "   ✅ Aucune PR ouverte" -ForegroundColor Green
}

# ───────────────────────────────────────────────────────────────────
# 8. RÉCAPITULATIF FINAL
# ───────────────────────────────────────────────────────────────────
Write-Host "`n═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  📋 RÉCAPITULATIF" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan

$allGood = $true

# Vérifier working tree
if ($gitStatus) { $allGood = $false }

# Vérifier main
git checkout main --quiet
$mainOk = -not (git status --branch --porcelain | Select-String "ahead|behind")
if (-not $mainOk) { $allGood = $false }

# Vérifier dev
git checkout dev --quiet
$devOk = -not (git status --branch --porcelain | Select-String "ahead|behind")
if (-not $devOk) { $allGood = $false }

if ($allGood) {
    Write-Host "`n  ✅ TOUT EST PROPRE ET SYNCHRONISÉ !" -ForegroundColor Green
    Write-Host "  🎉 Tu peux faire une pause en toute confiance" -ForegroundColor Green
} else {
    Write-Host "`n  ⚠️  IL RESTE DES CHOSES À NETTOYER !" -ForegroundColor Red
    Write-Host "  🔧 Voir les messages ci-dessus pour corriger" -ForegroundColor Red
}

Write-Host "`n═══════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

# Revenir sur dev (branche de travail)
git checkout dev --quiet
