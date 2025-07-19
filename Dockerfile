FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    nginx \
    php8.2 php8.2-cli php8.2-fpm php8.2-mysql php8.2-mbstring php8.2-curl php8.2-xml php8.2-zip php8.2-bcmath \
    mariadb-server \
    curl \
    unzip \
    git \
    nano \
    wget \
    nodejs \
    npm \
    supervisor \
    software-properties-common

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Create PHP socket directory
RUN mkdir -p /run/php

WORKDIR /var/www/html

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n"]
