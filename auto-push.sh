#!/bin/bash
set -e

DEPLOY_VERSION="${1:-v13}"

echo "🔍 Перевірка порту 80..."
if ss -ltn | grep ':80 '; then
    echo "⚠️ Порт 80 зайнятий. Зупиняємо nginx..."
    sudo systemctl stop nginx || true
fi

echo "🔒 Перевірка сертифікатів..."
if ! sudo ls /etc/letsencrypt/live/test.soundstorm.pp.ua/fullchain.pem >/dev/null 2>&1; then
    echo "❌ Сертифікат не знайдено!"
    exit 1
fi

echo "📦 Завантаження образу witcherua/test-soundstorm:$DEPLOY_VERSION"
sudo docker pull witcherua/test-soundstorm:$DEPLOY_VERSION

echo "🧹 Видалення старого контейнера..."
sudo docker stop test-soundstorm || true
sudo docker rm test-soundstorm || true

echo "🚀 Запуск нового контейнера версії $DEPLOY_VERSION"
sudo docker run -d \
  --name test-soundstorm \
  -v /etc/letsencrypt:/etc/letsencrypt:ro \
  -p 80:80 -p 443:443 \
  --restart unless-stopped \
  witcherua/test-soundstorm:$DEPLOY_VERSION

echo "✅ Контейнер запущено успішно!"
