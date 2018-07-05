FROM php:7.1-fpm
MAINTAINER Sébastien NOIRIE


RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        gnupg
        
RUN apt-get install -y --install-recommends dirmngr

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4

RUN echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.6 main" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get install -y nodejs

RUN apt-get update && \
    apt-get install -y --force-yes \
#        npm \
        openssh-client \
        curl \
#        nodejs \
#        nodejs-legacy \
        git \
#        libssl1.0.0 \
        mongodb-org-shell \
        rsync \
        build-essential \
        libmemcached-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
#        libpng12-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev \
        git-ftp

# Install the PHP extentions
RUN docker-php-ext-install mcrypt pdo_mysql zip


# Install the PHP gd library
RUN docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd

# Install ZIP
# RUN pecl install zip && docker-php-ext-enable zip


# Install exif
#RUN pecl install exif && docker-php-ext-enable exif

# Install Xdebug
RUN pecl install xdebug-2.5.5 && docker-php-ext-enable xdebug

# Install Mongodb
RUN pecl install mongodb && docker-php-ext-enable mongodb

# Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install PHP Code sniffer
RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
RUN mv phpcs.phar /usr/local/bin/phpcs
RUN chmod a+x /usr/local/bin/phpcs

# Install PHP Lint
RUN curl -OL https://raw.githubusercontent.com/overtrue/phplint/master/bin/phplint
RUN mv phplint /usr/local/bin/phplint
RUN chmod a+x /usr/local/bin/phplint

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
