FROM adminer:latest

USER root

COPY ./docker/adminer/login-password-less.php /var/www/html/plugins-enabled/login-password-less.php

RUN mkdir -p /var/www/html/db