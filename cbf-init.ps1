# CBF -- Claude Brokering Framework -- Installation (Windows)
# Usage: & "<chemin_CBF>\cbf-init.ps1" depuis la racine du projet cible

$CBF_ROOT    = Split-Path -Parent $MyInvocation.MyCommand.Path
$CLAUDE_DIR  = "$env:USERPROFILE\.claude"
$CBF_DIR     = "$CLAUDE_DIR\cbf"
$CALIB_DEST  = "$CLAUDE_DIR\bridge_calibration.md"
$BRIDGE_DEST = "$CBF_DIR\bridge.js"
$TARGET_MD   = Join-Path (Get-Location) "CLAUDE.md"

# 0. Verifier/configurer la cle API selon le provider (defaut: anthropic)
$provider = if ($env:CBF_PROVIDER) { $env:CBF_PROVIDER } else { "anthropic" }
$keyEnv   = if ($provider -eq "groq") { "GROQ_API_KEY" } else { "ANTHROPIC_API_KEY" }
$keyHint  = if ($provider -eq "groq") { "gsk_..." } else { "sk-ant-..." }

$apiKey = [System.Environment]::GetEnvironmentVariable($keyEnv, "User")
if (-not $apiKey) {
    $apiKey = Read-Host "Cle API ($provider / $keyHint)"
    [System.Environment]::SetEnvironmentVariable($keyEnv, $apiKey, "User")
    Set-Item "Env:\$keyEnv" $apiKey
    Write-Host "[CBF] $keyEnv configuree (persistee -- redemarrer CC pour prise en compte)"
} else {
    Write-Host "[CBF] $keyEnv deja configuree OK"
}

# 1. Creer ~/.claude/cbf/
if (-not (Test-Path $CBF_DIR)) {
    New-Item -ItemType Directory -Path $CBF_DIR -Force | Out-Null
}

# 2. Installer bridge.js
Copy-Item "$CBF_ROOT\src\bridge.js" $BRIDGE_DEST -Force
Write-Host "[CBF] bridge.js installe -> $BRIDGE_DEST"

# 3. Initialiser bridge_calibration.md (ne pas ecraser si existant)
if (-not (Test-Path $CALIB_DEST)) {
    Copy-Item "$CBF_ROOT\src\templates\bridge_calibration.md" $CALIB_DEST
    Write-Host "[CBF] bridge_calibration.md cree -> $CALIB_DEST"
} else {
    Write-Host "[CBF] bridge_calibration.md deja present -- conserve"
}

# 4. Injecter instruction Bridge dans CLAUDE.md du projet cible
$instruction = Get-Content "$CBF_ROOT\src\templates\claude_instruction.md" -Raw -Encoding utf8
if (Test-Path $TARGET_MD) {
    $existing = Get-Content $TARGET_MD -Raw -Encoding utf8
    if ($existing -match "CBF.*Claude Brokering Framework") {
        Write-Host "[CBF] Instruction Bridge deja presente dans CLAUDE.md -- ignore"
    } else {
        Add-Content $TARGET_MD "`n`n$instruction" -Encoding utf8
        Write-Host "[CBF] Instruction Bridge injectee -> $TARGET_MD"
    }
} else {
    Set-Content $TARGET_MD $instruction -Encoding utf8
    Write-Host "[CBF] CLAUDE.md cree -> $TARGET_MD"
}

# 5. Verifier Node.js >= 18 (fetch natif requis)
$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
    $ver   = node --version
    $major = [int]($ver -replace 'v(\d+).*', '$1')
    if ($major -ge 18) {
        Write-Host "[CBF] Node.js $ver OK"
    } else {
        Write-Host "[CBF] ATTENTION: Node.js >= 18 requis -- detecte: $ver"
    }
} else {
    Write-Host "[CBF] ATTENTION: Node.js non trouve -- requis pour bridge.js"
}

Write-Host ""
Write-Host "[CBF] Installation terminee."
Write-Host "      bridge.js   : $BRIDGE_DEST"
Write-Host "      calibration : $CALIB_DEST"
Write-Host "      instruction : $TARGET_MD"
