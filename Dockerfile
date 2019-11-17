FROM php:7.2-fpm-buster
RUN apt-get update && apt-get install -y curl gnupg2 libssl-dev software-properties-common

RUN curl http://packages.couchbase.com/ubuntu/couchbase.key | apt-key add -
RUN apt-add-repository "deb http://packages.couchbase.com/ubuntu buster buster/main"


RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libxml2-dev \
        zlib1g-dev libicu-dev g++ \
        libcurl4 libcurl4-gnutls-dev \
        imagemagick libmagickwand-dev libmagickcore-dev \
        libxslt1-dev \
        libmemcached-dev \
        cron git mariadb-client unzip \
        libcouchbase-dev build-essential \
        libmcrypt-dev libmcrypt4 \
        --no-install-recommends

RUN docker-php-ext-install \
    opcache session mbstring iconv pdo dom mysqli curl json xml exif \
	gd \
	bcmath \
	intl \
	pdo_mysql \
	soap \
	xsl \
	zip \
	calendar

RUN docker-php-ext-configure \
	gd --with-jpeg-dir=/usr/local/ --with-freetype-dir=/usr/include/

RUN pecl install apcu couchbase imagick redis memcached calendar mcrypt-1.0.3

RUN docker-php-ext-enable apcu couchbase imagick redis memcached calendar mcrypt

RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

RUN curl -O https://files.magerun.net/n98-magerun2.phar && chmod +x ./n98-magerun2.phar && mv ./n98-magerun2.phar /usr/local/bin/magerun
RUN curl -O https://files.magerun.net/n98-magerun.phar && chmod +x ./n98-magerun.phar && mv ./n98-magerun.phar /usr/local/bin/magerun1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR "/var/www/"
