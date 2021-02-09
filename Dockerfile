FROM bitnami/php-fpm:7.3 as builder

ENV REDIS_VERSION="5.3.3"

RUN install_packages git autoconf build-essential

# Redis
RUN wget https://pecl.php.net/get/redis-${REDIS_VERSION}.tgz && \
    tar xzf redis-${REDIS_VERSION}.tgz && \
    cd redis-${REDIS_VERSION} && \
    phpize && ./configure && \
    make && make install && \
    cd .. && rm -rf redis-${REDIS_VERSION}


FROM bitnami/php-fpm:7.3-prod

# OPcache defaults
ENV PHP_OPCACHE_ENABLE=1 \
    PHP_OPCACHE_MEMORY_CONSUMPTION=128 \
    PHP_OPCACHE_INTERNED_STRINGS_BUFFER=8 \
    PHP_OPCACHE_MAX_ACCELERATED_FILES=15000 \
    PHP_OPCACHE_REVALIDATE_FREQUENCY=0 \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=0 \
    PHP_OPCACHE_ENABLE_CLI=1

# PHP-FPM defaults
ENV PHP_FPM_PM="dynamic" \
    PHP_FPM_MAX_CHILDREN=100 \
    PHP_FPM_START_SERVERS=2 \
    PHP_FPM_MIN_SPARE_SERVERS=1 \
    PHP_FPM_MAX_SPARE_SERVERS=2 \
    PHP_FPM_MAX_REQUESTS=1000 \
    PHP_FPM_PROCESS_IDEL_TIMEOUT="300s"

# Redis
COPY --from=builder \
    /opt/bitnami/php/lib/php/extensions/redis.so \
    /opt/bitnami/php/lib/php/extensions/

# config files
COPY config/php-kuri.ini /opt/bitnami/php/etc/conf.d/php-kuri.ini
COPY config/php-fpm/www.conf /opt/bitnami/php/etc/php-fpm.d/www.conf