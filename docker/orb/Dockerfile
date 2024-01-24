FROM docker.io/library/php:8.2-apache
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# install dependencies, PHP module, Apache module
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -qq -y install libxslt1.1 libxslt1-dev argon2 && apt-get clean
RUN docker-php-ext-install xsl
RUN a2enmod rewrite
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# deploy Orb and prepare demo user
ENV ORB_DIR=/var/www/orb
COPY orb $ORB_DIR
COPY orb_user.sh $ORB_DIR/orb_user.sh
RUN chmod a+x $ORB_DIR/orb_user.sh && $ORB_DIR/orb_user.sh demo demo

# repair file ownership
RUN chown www-data:www-data -R $ORB_DIR