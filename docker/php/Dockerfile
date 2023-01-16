FROM php:8.1-apache

WORKDIR /var/www/html

# Server
RUN apt-get update && apt-get install -y \
		acl \
		apt-utils \
		build-essential \
		git \
		htop \
		libicu-dev \
		libpq-dev \
		libpng-dev \
		libssh-dev \
		libzip-dev \
		libwebp-dev \
		libonig-dev \
		nano \
		pkg-config \
		supervisor \
		unzip \
		wget \
		zip \
		sqlite3 \
		libsqlite3-dev \
    ;

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql

RUN docker-php-ext-install \
		pdo_mysql \
		pdo_pgsql \
		pgsql \
		zip \
		opcache \
		iconv \
		sockets \
		pcntl \
		intl \
	;

COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/php.ini
COPY ./docker/php/vhost-app.conf /etc/apache2/sites-available/

RUN a2enmod rewrite

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN echo "ServerName app.local" >> /etc/apache2/apache2.conf

RUN a2dissite 000-default.conf \
    && a2ensite vhost-app.conf

RUN useradd -r --create-home -u 998 1000 \
    && adduser 1000 root \
    && adduser 1000 www-data \
    && echo '%998 ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Symfony CLI
RUN wget https://get.symfony.com/cli/installer -O - | bash \
    && chmod +x /root/.symfony5/bin/symfony \
    && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# APCU
RUN pear config-set http_proxy "${http_proxy}" \
    && pecl channel-update pecl.php.net \
    && pecl install apcu
RUN echo "extension=apcu.so\napc.enable_cli=on" > /usr/local/etc/php/conf.d/apcu.ini

# X-Debug
RUN pecl install xdebug-3.2.0 \
    && docker-php-ext-enable xdebug

CMD ["apache2-foreground"]