FROM php:7.4-apache
LABEL maintainer="Ralph Schuster <github@ralph-schuster.eu>"

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y --no-install-recommends \
    wget libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libmagickwand-dev ghostscript libzip-dev libldb-dev libldap2-dev vim \
    && pecl install imagick \
    && docker-php-ext-configure gd \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install -j$(nproc) pdo_mysql intl exif ldap gd zip \
    && apt-get purge -y libicu-dev libzip-dev libmagickwand-dev libldb-dev libldap2-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

#ADD etc/php/ /usr/local/etc/php/conf.d/
#ADD etc/conf/ /etc/apache2/conf-enabled/
#ADD etc/mods/ /etc/apache2/mods-enabled/
#ADD etc/sites/ /etc/apache2/sites-enabled/
#ADD src/    /var/www/html/
RUN chown -R www-data:www-data /var/www/html
ENV ROUNDCUBE_VERSION="1.4.8"
ENV ROUNDCUBE_REVISION="0"

RUN cd /var/www/html \
    && wget -O roundcube.tar.gz https://github.com/roundcube/roundcubemail/releases/download/${ROUNDCUBE_VERSION}/roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz \
    && tar --strip-components=1 -xvf roundcube.tar.gz \
    && rm roundcube.tar.gz;

COPY config.inc.php /var/www/html/config/config.inc.php

RUN chown -R www-data:www-data .

#####################################################################
#  Image OCI labels
#####################################################################
ARG ARG_CREATED
ARG ARG_URL=https://github.com/technicalguru/docker-mailserver-roundcube
ARG ARG_SOURCE=https://github.com/technicalguru/docker-mailserver-roundcube
ARG ARG_VERSION="${ROUNDCUBE_VERSION}.${ROUNDCUBE_REVISION}"
ARG ARG_REVISION="${ROUNDCUBE_REVISION}"
ARG ARG_VENDOR=technicalguru
ARG ARG_TITLE=technicalguru/mailserver-roundcube
ARG ARG_DESCRIPTION="Provides Roundcube Webmailer UI with Apache/PHP"
ARG ARG_DOCUMENTATION=https://github.com/technicalguru/docker-mailserver-roundcube
ARG ARG_AUTHORS=technicalguru
ARG ARG_LICENSES=GPL-3.0-or-later

LABEL org.opencontainers.image.created=$ARG_CREATED
LABEL org.opencontainers.image.url=$ARG_URL
LABEL org.opencontainers.image.source=$ARG_SOURCE
LABEL org.opencontainers.image.version=$ARG_VERSION
LABEL org.opencontainers.image.revision=$ARG_REVISION
LABEL org.opencontainers.image.vendor=$ARG_VENDOR
LABEL org.opencontainers.image.title=$ARG_TITLE
LABEL org.opencontainers.image.description=$ARG_DESCRIPTION
LABEL org.opencontainers.image.documentation=$ARG_DOCUMENTATION
LABEL org.opencontainers.image.authors=$ARG_AUTHORS
LABEL org.opencontainers.image.licenses=$ARG_LICENSES

