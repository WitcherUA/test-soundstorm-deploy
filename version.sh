#!/bin/bash
set -e

# Отримати останній тег з remote (якщо немає — v0)
LAST_TAG=$(git ls-remote --tags origin | awk -F'/' '{print $3}' | sort -V | tail -n1)
if [[ -z "$LAST_TAG" ]]; then
  LAST_TAG="v0"
fi

# Витягнути число після v
LAST_NUM=${LAST_TAG#v}

# Якщо порожньо — починаємо з 0
if [[ -z "$LAST_NUM" ]]; then
  LAST_NUM=0
fi

# Інкрементуємо
NEXT_NUM=$((LAST_NUM + 1))
NEXT_TAG="v${NEXT_NUM}"

echo "Last remote tag: $LAST_TAG"
echo "Next tag will be: $NEXT_TAG"

# Побудувати Docker‑образ з двома тегами: latest і v0.x
docker build -t witcherua/test-soundstorm:latest -t witcherua/test-soundstorm:$NEXT_TAG .

# Запушити обидва теги
docker push witcherua/test-soundstorm:latest
docker push witcherua/test-soundstorm:$NEXT_TAG

# Створити git‑тег локально і запушити його
git tag "$NEXT_TAG"
git push origin "$NEXT_TAG"

# Записати output для GitHub Actions
echo "tag=$NEXT_TAG" >> "$GITHUB_OUTPUT"
