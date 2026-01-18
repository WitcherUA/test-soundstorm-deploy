#!/bin/bash
set -e

# Налаштування Git (один раз)
git config --global user.name "auto-deploy"
git config --global user.email "auto-deploy@vm.local"

# Додати всі зміни
git add .

# Коміт з повідомленням
git commit -m "Auto: deploy changes from VM" || echo "⚠️ Немає змін для коміту"

# Пуш у main
git push origin main
