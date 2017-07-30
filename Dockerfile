FROM ubuntu:14.04

RUN    apt-get update
RUN    apt-get install curl -y
RUN    apt-get install -y wget
RUN    apt-get install -y vim
RUN    apt-get install -y supervisor

RUN    apt-get install software-properties-common -y
RUN    add-apt-repository ppa:nginx/stable

RUN    apt-get update
RUN    apt-get install -y nginx
RUN    add-apt-repository --remove ppa:nginx/stable

#Install PHP 7.1
RUN    add-apt-repository ppa:ondrej/php -y
RUN    apt-get update
RUN    apt-get install -y php7.1 php7.1-fpm php7.1-common  php7.1-bcmath php7.1-curl \
                       php7.1-curl php7.1-cli php7.1-mysql php7.1-gd  php7.1-xsl php7.1-zip --force-yes

RUN    add-apt-repository --remove ppa:ondrej/php

#Install mysql 5.7
RUN    add-apt-repository ppa:ondrej/mysql-5.7
RUN    apt-get update
RUN    apt-get install mysql-server -y


# Install composer 
RUN    curl -sS https://getcomposer.org/installer | php
RUN    mv composer.phar /usr/local/bin/composer

#Install Redis
RUN    apt-get install libpam-smbpass -y
RUN    add-apt-repository ppa:chris-lea/redis-server
RUN    apt-get update
RUN    apt-get install redis-server -y

COPY   config/default    /etc/nginx/sites-available/
COPY   config/www.conf   /etc/php7/fpm/pool.d/www.conf
COPY   config/service.conf /etc/supervisor/conf.d/service.conf

RUN    mkdir -p  /var/www/trunk
#EXPOSE  22 80 3306
CMD ["/usr/bin/supervisord"]

