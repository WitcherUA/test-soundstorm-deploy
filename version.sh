#!/bin/bash
set -e

# Отримати останній тег з remote (якщо немає — v0)
LAST_TAG=$(git ls-remote --tags origin | awk -F'/' '{print $3}' | sort -V | tail -n1)
if [[ -z "$LAST_TAG" ]]; then
  LAST_TAG="v0"
fi

# Витягнути число після v
LAST_NUM=${LAST_TAG#v}
if [[ -z "$LAST_NUM" ]]; then
  LAST_NUM=0
fi

# Інкрементуємо
NEXT_NUM=$((LAST_NUM + 1))
NEXT_TAG="v${NEXT_NUM}"

# Інформативні повідомлення у stderr
echo "Last remote tag: $LAST_TAG" >&2
echo "Next tag will be $NEXT_TAG" >&2

# Побудувати Docker‑образ з двома тегами: latest і vX
docker build -t witcherua/test-soundstorm:latest -t witcherua/test-soundstorm:$NEXT_TAG . >&2

# Запушити обидва теги
docker push witcherua/test-soundstorm:latest >&2
docker push witcherua/test-soundstorm:$NEXT_TAG >&2

# Створити git‑тег локально і запушити його (якщо ще немає)
if git rev-parse "$NEXT_TAG" >/dev/null 2>&1; then
  echo "Local tag $NEXT_TAG вже існує, пропускаю..." >&2
else
  git tag "$NEXT_TAG"
  git push origin "$NEXT_TAG" >&2
fi

# Записати output для GitHub Actions (єдиний рядок у stdout)
echo "tag=$NEXT_TAG" >> "$GITHUB_OUTPUT"
