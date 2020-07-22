FROM php:7.3-apache
ARG SSH_PASS=test
ARG SSH_USER=test
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install --fix-missing openssh-server git && \
    rm -rf /var/lib/apt/lists/*
RUN useradd -m -s /bin/bash -p $(openssl passwd -1 $SSH_PASS) $SSH_USER
RUN usermod -g www-data $SSH_USER && usermod -a -G www-data,root root
CMD chmod 0755 /var/www/html/docker/start.sh && /var/www/html/docker/start.sh && apache2-foreground
