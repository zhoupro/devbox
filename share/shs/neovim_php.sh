#!/bin/bash
echo "php vim"
sudo apt install -y php php-curl php-dom php-xdebug php-fpm


wget https://getcomposer.org/composer.phar -O composer  && \
chmod u+x composer  && mv composer /usr/local/bin/ && \
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/


