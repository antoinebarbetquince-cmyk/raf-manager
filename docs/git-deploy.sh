#!/bin/bash
# ============================================================
#  RAF Manager — Script de déploiement Git
#  À exécuter sur votre machine locale après avoir dézippé
# ============================================================

set -e

echo "🚀 RAF Manager — Push vers GitHub"
echo "Compte : antoinebarbetquince-cmyk"
echo ""

# 1. Se placer dans le bon dossier
cd "$(dirname "$0")/.."

# 2. Vérifier que git est installé
if ! command -v git &> /dev/null; then
  echo "❌ Git n'est pas installé. Installez-le depuis https://git-scm.com"
  exit 1
fi

# 3. Init si pas déjà fait
if [ ! -d ".git" ]; then
  git init
  git branch -M main
fi

# 4. Config identité
git config user.name "Antoine Barbet-Quince"
git config user.email "antoinebarbetquince-cmyk@users.noreply.github.com"

# 5. Remote
git remote remove origin 2>/dev/null || true
git remote add origin https://github.com/antoinebarbetquince-cmyk/raf-manager.git

# 6. Commit
git add .
git commit -m "feat: RAF Manager v1.0 — initial release" 2>/dev/null || echo "(rien à committer)"

# 7. Push
echo ""
echo "📤 Push vers https://github.com/antoinebarbetquince-cmyk/raf-manager"
echo "→ GitHub va vous demander votre token d'accès (Personal Access Token)"
echo "  Créez-en un sur : https://github.com/settings/tokens/new"
echo "  Permissions requises : repo (lecture + écriture)"
echo ""
git push -u origin main

echo ""
echo "✅ Déployé ! Votre repo : https://github.com/antoinebarbetquince-cmyk/raf-manager"
