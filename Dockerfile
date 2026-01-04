FROM nginx:1.25

# Створюємо папку для сертифікатів
RUN mkdir -p /etc/nginx/ssl/

# Копіюємо сайт
COPY site/ /usr/share/nginx/html/

# Копіюємо конфіг
COPY docker/default.conf /etc/nginx/conf.d/default.conf

# Копіюємо сертифікати
COPY certs/ /etc/nginx/ssl/

# Даємо доступ до сертифікатів
RUN chmod 644 /etc/nginx/ssl/*.pem

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
