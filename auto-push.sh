#!/bin/bash

cd ~/test-soundstorm-deploy || exit 1

echo "🔍 Перевіряємо зміни..."
git add .

# Коміт з міткою часу
git commit -m "Auto-push from VM: $(date '+%Y-%m-%d %H:%M:%S')" || echo "ℹ️ Немає змін для коміту"

# Пуш у main з перевіркою конфліктів
echo "📤 Відправляємо у GitHub..."
git pull --rebase origin main || {
  echo "⚠️ Конфлікт при rebase, спробуй вирішити вручну!"
  exit 1
}

git push origin main --force-with-lease
echo "✅ Автопуш завершено, GitHub Actions має стартувати!"
