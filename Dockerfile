FROM ubuntu:14.04

RUN  apt-get update
RUN  apt-get -y install curl \
                        wget \
                        vim \
                        supervisor

# Install mysql 5.6
RUN apt-get -y install mysql-server-5.6

# Install nginx 
RUN  apt-get install software-properties-common -y
RUN  add-apt-repository ppa:nginx/stable

RUN  apt-get update
RUN  apt-get install -y nginx
RUN  add-apt-repository --remove ppa:nginx/stable

#Install PHP 7.1
RUN  add-apt-repository ppa:ondrej/php -y
RUN  apt-get update
RUN  apt-get install -y php7.1 php7.1-fpm php7.1-common  php7.1-bcmath php7.1-curl php7.1-mbstring \
                        php7.1-curl php7.1-cli php7.1-mysql php7.1-gd  php7.1-xsl php7.1-zip php7.1-intl --force-yes

RUN  add-apt-repository --remove ppa:ondrej/php

# Install composer 
RUN  curl -sS https://getcomposer.org/installer | php
RUN  mv composer.phar /usr/local/bin/composer

RUN  export DEBIAN_FRONTEND=noninteractive


#Install Redis
RUN  apt-get install libpam-smbpass -y
RUN  add-apt-repository ppa:chris-lea/redis-server
RUN  apt-get update
RUN  apt-get install redis-server -y

COPY  config/default    /etc/nginx/sites-available/
COPY  config/www.conf   /etc/php7/fpm/pool.d/www.conf
COPY  config/service.conf /etc/supervisor/conf.d/service.conf

RUN  mkdir -p  /var/www/trunk

CMD ["/usr/bin/supervisord"]
