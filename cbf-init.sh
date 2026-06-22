#!/usr/bin/env bash
# CBF — Claude Brokering Framework — Script d'installation (Linux/Mac)
# Usage: depuis la racine du projet cible : bash <chemin_CBF>/cbf-init.sh

set -e

CBF_ROOT="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CBF_DIR="$CLAUDE_DIR/cbf"
CALIB_DEST="$CLAUDE_DIR/bridge_calibration.md"
BRIDGE_DEST="$CBF_DIR/bridge.js"
TARGET_MD="$(pwd)/CLAUDE.md"

# 0. Verifier/configurer la cle API selon le provider (defaut: anthropic)
PROVIDER="${CBF_PROVIDER:-anthropic}"
if [ "$PROVIDER" = "groq" ]; then KEY_ENV="GROQ_API_KEY"; KEY_HINT="gsk_..."; else KEY_ENV="ANTHROPIC_API_KEY"; KEY_HINT="sk-ant-..."; fi

if [ -z "${!KEY_ENV}" ]; then
    read -r -s -p "[CBF] Cle API ($PROVIDER / $KEY_HINT): " api_key
    echo ""
    export "$KEY_ENV"="$api_key"
    PROFILE="$HOME/.bashrc"
    [ -f "$HOME/.zshrc" ] && PROFILE="$HOME/.zshrc"
    echo "export $KEY_ENV=\"$api_key\"" >> "$PROFILE"
    echo "[CBF] $KEY_ENV configuree -> $PROFILE (redemarrer le shell pour prise en compte)"
else
    echo "[CBF] $KEY_ENV deja configuree OK"
fi

# 1. Créer ~/.claude/cbf/
mkdir -p "$CBF_DIR"

# 2. Installer bridge.js
cp "$CBF_ROOT/src/bridge.js" "$BRIDGE_DEST"
echo "[CBF] bridge.js installé → $BRIDGE_DEST"

# 3. Initialiser bridge_calibration.md (ne pas écraser si existant)
if [ ! -f "$CALIB_DEST" ]; then
    cp "$CBF_ROOT/src/templates/bridge_calibration.md" "$CALIB_DEST"
    echo "[CBF] bridge_calibration.md créé → $CALIB_DEST"
else
    echo "[CBF] bridge_calibration.md déjà présent — conservé"
fi

# 4. Injecter instruction Bridge dans CLAUDE.md du projet cible
if [ -f "$TARGET_MD" ]; then
    if grep -q "CBF — Claude Brokering Framework" "$TARGET_MD"; then
        echo "[CBF] Instruction Bridge déjà présente dans CLAUDE.md — ignoré"
    else
        printf "\n\n" >> "$TARGET_MD"
        cat "$CBF_ROOT/src/templates/claude_instruction.md" >> "$TARGET_MD"
        echo "[CBF] Instruction Bridge injectée → $TARGET_MD"
    fi
else
    cp "$CBF_ROOT/src/templates/claude_instruction.md" "$TARGET_MD"
    echo "[CBF] CLAUDE.md créé → $TARGET_MD"
fi

# 5. Vérifier Node.js >= 18 (fetch natif requis)
if command -v node &>/dev/null; then
    NODE_MAJOR=$(node --version | sed 's/v\([0-9]*\).*/\1/')
    if [ "$NODE_MAJOR" -ge 18 ]; then
        echo "[CBF] Node.js $(node --version) ✓"
    else
        echo "[CBF] ATTENTION : Node.js >= 18 requis — détecté : $(node --version)"
    fi
else
    echo "[CBF] ATTENTION : Node.js non trouvé — requis pour bridge.js"
fi

echo ""
echo "[CBF] Installation terminée."
echo "      bridge.js   : $BRIDGE_DEST"
echo "      calibration : $CALIB_DEST"
echo "      instruction : $TARGET_MD"
