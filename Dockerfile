FROM bitnami/php-fpm:7.3-prod

ENV REDIS_VERSION="5.3.3"

# OPcache defaults
ENV PHP_OPCACHE_ENABLE="1" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="128" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
    PHP_OPCACHE_REVALIDATE_FREQUENCY="0" \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="128"

# PHP-FPM defaults
ENV PHP-FPM-PM="dynamic" \
    PHP_FPM_MAX_CHILDREN="100" \
    PHP_FPM_START_SERVERS="2" \
    PHP_FPM_MIN_SPARE_SERVERS="1" \
    PHP_FPM_MAX_SPARE_SERVERS="2" \
    PHP_FPM_MAX_REQUESTS="1000" \
    PHP_FPM_PROCESS_IDEL_TIMEOUT="300s"

RUN apt-get update && \
    apt-get install -y autoconf

# Redis
RUN wget https://pecl.php.net/get/redis-${REDIS_VERSION}.tgz && \
    tar xzf redis-${REDIS_VERSION}.tgz && \
    cd redis-${REDIS_VERSION} && \
    phpize && ./configure && \
    make && make install && \
    cd .. && rm -rf redis-${REDIS_VERSION}

# Clear cache
RUN rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY config/php-kuri.ini /opt/bitnami/php/etc/conf.d/php-kuri.ini

