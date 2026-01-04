FROM nginx:1.25-alpine

# Копіюємо конфіг nginx
COPY docker/default.conf /etc/nginx/conf.d/default.conf

# Копіюємо сайт
COPY site/ /usr/share/nginx/html

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
