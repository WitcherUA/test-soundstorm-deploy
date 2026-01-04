FROM nginx:1.25-alpine

# Копіюємо сайт
COPY app /usr/share/nginx/html

# Кастомний конфіг (опційно)
COPY app/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
