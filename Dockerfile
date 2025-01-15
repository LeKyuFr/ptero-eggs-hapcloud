FROM alpine:latest

# Installer les dépendances nécessaires, y compris PHP et NGINX
RUN apk --update --no-cache add curl ca-certificates nginx \
    php8 php8-xml php8-exif php8-fpm php8-session php8-soap php8-openssl php8-gmp \
    php8-pdo_odbc php8-json php8-dom php8-pdo php8-zip php8-mysqli php8-sqlite3 php8-pdo_pgsql \
    php8-bcmath php8-gd php8-odbc php8-pdo_mysql php8-pdo_sqlite php8-gettext php8-xmlreader \
    php8-bz2 php8-iconv php8-pdo_dblib php8-curl php8-ctype php8-phar php8-fileinfo \
    php8-mbstring php8-tokenizer php8-simplexml

# Télécharger et installer IonCube Loader
RUN curl -fsSL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -o ioncube.tar.gz && \
    tar -xzf ioncube.tar.gz && \
    cp ioncube/ioncube_loader_lin_8.1.so /usr/lib/php8/modules/ && \
    rm -rf ioncube.tar.gz ioncube

# Ajouter IonCube dans un fichier de configuration séparé
RUN echo "zend_extension=ioncube_loader_lin_8.1.so" > /etc/php8/conf.d/00_ioncube.ini

# Copier Composer depuis l'image Composer officielle
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Définir l'utilisateur par défaut
USER container
ENV USER container
ENV HOME /home/container

# Définir le répertoire de travail
WORKDIR /home/container

# Copier le script d'entrée
COPY ./entrypoint.sh /entrypoint.sh

# Commande d'exécution par défaut
CMD ["/bin/ash", "/entrypoint.sh"]
