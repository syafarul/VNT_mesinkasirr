FROM php:8.2-fpm
COPY composer.* /var/www/kasir_vnt/
WORKDIR /var/www/kasir_vnt
RUN apt-get update && apt-get install -y \
    build-essential \
    libmcrypt-dev \
    mariadb-client \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libzip-dev \
    zip \
    libicu-dev
RUN docker-php-ext-configure intl
RUN docker-php-ext-install pdo pdo_mysql gd zip intl
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN groupadd -g 1000 www
RUN useradd -u 1000 -g www -s /bin/bash -m www
COPY . .
COPY --chown=www:www . .
USER www
EXPOSE 9000
CMD ["php-fpm"]

