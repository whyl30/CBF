# CBF — Claude Brokering Framework — Script d'installation (Windows)
# Usage: depuis la racine du projet cible : & "<chemin_CBF>\cbf-init.ps1"

$CBF_ROOT    = Split-Path -Parent $MyInvocation.MyCommand.Path
$CLAUDE_DIR  = "$env:USERPROFILE\.claude"
$CBF_DIR     = "$CLAUDE_DIR\cbf"
$CALIB_DEST  = "$CLAUDE_DIR\bridge_calibration.md"
$BRIDGE_DEST = "$CBF_DIR\bridge.js"
$TARGET_MD   = Join-Path (Get-Location) "CLAUDE.md"

# 1. Créer ~/.claude/cbf/
if (-not (Test-Path $CBF_DIR)) {
    New-Item -ItemType Directory -Path $CBF_DIR -Force | Out-Null
}

# 2. Installer bridge.js
Copy-Item "$CBF_ROOT\src\bridge.js" $BRIDGE_DEST -Force
Write-Host "[CBF] bridge.js installé → $BRIDGE_DEST"

# 3. Initialiser bridge_calibration.md (ne pas écraser si existant)
if (-not (Test-Path $CALIB_DEST)) {
    Copy-Item "$CBF_ROOT\src\templates\bridge_calibration.md" $CALIB_DEST
    Write-Host "[CBF] bridge_calibration.md créé → $CALIB_DEST"
} else {
    Write-Host "[CBF] bridge_calibration.md déjà présent — conservé"
}

# 4. Injecter instruction Bridge dans CLAUDE.md du projet cible
$instruction = Get-Content "$CBF_ROOT\src\templates\claude_instruction.md" -Raw -Encoding utf8
if (Test-Path $TARGET_MD) {
    $existing = Get-Content $TARGET_MD -Raw -Encoding utf8
    if ($existing -match "CBF — Claude Brokering Framework") {
        Write-Host "[CBF] Instruction Bridge déjà présente dans CLAUDE.md — ignoré"
    } else {
        Add-Content $TARGET_MD "`n`n$instruction" -Encoding utf8
        Write-Host "[CBF] Instruction Bridge injectée → $TARGET_MD"
    }
} else {
    Set-Content $TARGET_MD $instruction -Encoding utf8
    Write-Host "[CBF] CLAUDE.md créé → $TARGET_MD"
}

# 5. Vérifier Node.js >= 18 (fetch natif requis)
$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
    $ver   = node --version
    $major = [int]($ver -replace 'v(\d+).*', '$1')
    if ($major -ge 18) {
        Write-Host "[CBF] Node.js $ver ✓"
    } else {
        Write-Host "[CBF] ATTENTION : Node.js >= 18 requis — détecté : $ver"
    }
} else {
    Write-Host "[CBF] ATTENTION : Node.js non trouvé — requis pour bridge.js"
}

Write-Host ""
Write-Host "[CBF] Installation terminée."
Write-Host "      bridge.js   : $BRIDGE_DEST"
Write-Host "      calibration : $CALIB_DEST"
Write-Host "      instruction : $TARGET_MD"
