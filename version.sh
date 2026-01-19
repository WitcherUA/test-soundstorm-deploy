#!/bin/bash
set -e

# Отримати останній git‑тег (якщо немає — v0)
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0")

# Витягнути тільки число після v
LAST_NUM=$(echo "$LAST_TAG" | sed 's/^v//')

# Якщо порожньо — починаємо з 0
if [[ -z "$LAST_NUM" ]]; then
  LAST_NUM=0
fi

# Інкрементуємо
NEXT_NUM=$((LAST_NUM + 1))
NEXT_TAG="v${NEXT_NUM}"

echo "Last tag: $LAST_TAG"
echo "Next tag: $NEXT_TAG"

# Побудувати Docker‑образ з двома тегами: latest і v0.x
docker build -t witcherua/test-soundstorm:latest -t witcherua/test-soundstorm:$NEXT_TAG .

# Запушити обидва теги
docker push witcherua/test-soundstorm:latest
docker push witcherua/test-soundstorm:$NEXT_TAG

# Створити git‑тег, якщо його ще немає
if git rev-parse "$NEXT_TAG" >/dev/null 2>&1; then
  echo "Git tag $NEXT_TAG вже існує, пропускаю..."
else
  git tag "$NEXT_TAG"
  git push origin "$NEXT_TAG"
fi

# Вивести тег як output для GitHub Actions
echo "tag=$NEXT_TAG" >> "$GITHUB_OUTPUT"
