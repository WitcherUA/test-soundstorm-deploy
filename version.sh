#!/bin/bash
set -e

# Отримати останній тег (наприклад v0.2). Якщо тегів немає — fallback v0.0
VERSION=$(git tag --sort=-v:refname | head -n 1)
if [[ -z "$VERSION" ]]; then VERSION="v0.0"; fi

# Розібрати MAJOR.MINOR
IFS='.' read -r MAJOR MINOR <<< "${VERSION#v}"
MINOR=$((MINOR+1))

# bump MAJOR якщо MINOR >= 10
if [[ "$MINOR" -ge 10 ]]; then
  MAJOR=$((MAJOR+1))
  MINOR=0
fi

NEW_VERSION="v$MAJOR.$MINOR"

# 🔁 Цикл: якщо тег вже існує — інкрементуємо далі
while git rev-parse "$NEW_VERSION" >/dev/null 2>&1; do
  MINOR=$((MINOR+1))
  if [[ "$MINOR" -ge 10 ]]; then
    MAJOR=$((MAJOR+1))
    MINOR=0
  fi
  NEW_VERSION="v$MAJOR.$MINOR"
done

# Створити і запушити новий тег
git tag "$NEW_VERSION"
git push origin "$NEW_VERSION"
echo "✅ Створено тег: $NEW_VERSION"

# Вивести notice у GitHub Actions
echo "::notice title=Version bumped::$NEW_VERSION"

# Передати значення у GITHUB_OUTPUT (без 'v')
echo "tag=${NEW_VERSION#v}" >> "$GITHUB_OUTPUT"
