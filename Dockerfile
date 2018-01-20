FROM php:7.1-fpm
MAINTAINER Sébastien NOIRIE

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        curl \
        apt-get install apt-transport-https \
        mysql-client \
        nodejs \
        nodejs-legacy \
        npm \
        openssh-client \
        rsync \
        build-essential \
        libmemcached-dev \
        mongodb-org-shell \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng12-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev \
        git-ftp

# Install the PHP extentions
RUN docker-php-ext-install mcrypt pdo_mysql zip mongodb


# Install the PHP gd library
RUN docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd

# Install ZIP
# RUN pecl install zip && docker-php-ext-enable zip

# Install Xdebug
RUN pecl install xdebug-2.5.5 && docker-php-ext-enable xdebug

# Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Update nodejs to stable version
RUN npm cache clean -f
RUN npm install -g n
RUN n stable

# Install Gulp
RUN npm install -g gulp

# Install PIP
RUN curl -O https://bootstrap.pypa.io/get-pip.py && python get-pip.py && rm get-pip.py

# SSH configuration
RUN mkdir -p ~/.ssh
