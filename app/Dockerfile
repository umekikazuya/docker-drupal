# --- Base Stage(中間イメージ) ---
FROM php:8.4-apache AS runtime-base

ARG ENV
ENV CONF=./php-apache/conf
ENV MODULE=./php-apache/module
ENV APACHE_HOME=/etc/apache2
ENV TZ=Asia/Tokyo
ENV PATH="/var/www/html/vendor/bin:$PATH"
ENV HOME="/var/www/html"

RUN apt-get update \
  && apt-get -y install \
  zlib1g-dev \
  libwebp-dev \
  libpng-dev \
  libzip-dev \
  libyaml-dev \
  linux-libc-dev \
  libjpeg62-turbo-dev \
  libavif-dev \
  && rm -rf /var/lib/apt/lists/*

RUN pecl install apcu yaml \
  && docker-php-ext-enable apcu yaml \
  && docker-php-ext-configure gd --with-jpeg --with-webp --with-avif \
  && docker-php-ext-install gd opcache pdo_mysql zip

RUN usermod --non-unique --uid 1000 www-data \
  && groupmod --non-unique --gid 1000 www-data

RUN mkdir -p /var/www/html \
  && mkdir -p /var/www/html/web/sites/default/files \
  && mkdir -p /var/www/lb_htalth_check \
  && chown -R www-data:www-data /var/www/html /var/www/lb_htalth_check

# Apache関連の権限設定(アプリソースコードの権限設定は composer install 後に実施)
COPY ${CONF}/apache/htalth_check.html /var/www/lb_htalth_check/htalth_check.html
COPY ${CONF}/apache/apache2.conf ${APACHE_HOME}/apache2.conf
COPY ${CONF}/apache/ports.conf ${APACHE_HOME}/ports.conf
COPY ${CONF}/apache/drupal.conf ${APACHE_HOME}/sites-available/drupal.conf
COPY ${CONF}/apache/forbidden_list.inc ${APACHE_HOME}/sites-enabled/forbidden_list.inc
COPY ${CONF}/apache/mpm_prefork.conf ${APACHE_HOME}/mods-available/mpm_prefork.conf
COPY ${CONF}/apache/charset.conf ${APACHE_HOME}/conf-available/charset.conf
RUN a2dissite 000-default \
  && a2ensite drupal \
  && a2enmod headers rewrite

WORKDIR /var/www/html

EXPOSE 80

# --- Toolchain Stage(中間イメージ) ---
FROM runtime-base AS toolchain-base

RUN apt-get update \
  && apt-get -y install \
  curl \
  unzip \
  default-mysql-client \
  git \
  lsof \
  && rm -rf /var/lib/apt/lists/*

COPY --from=public.ecr.aws/docker/library/composer:latest /usr/bin/composer /usr/bin/composer
COPY --chown=www-data:www-data composer.json composer.lock ./

# --- Dev Stage(compose環境) ---
FROM toolchain-base AS dev

CMD ["apache2-foreground"]
