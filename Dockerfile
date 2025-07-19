FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    php8.1 php8.1-cli php8.1-common php8.1-mbstring php8.1-xml php8.1-curl php8.1-mysql \
    php8.1-bcmath php8.1-gd php8.1-zip php8.1-fpm unzip curl git nginx mariadb-server \
    redis composer supervisor && \
    apt clean

EXPOSE 80
