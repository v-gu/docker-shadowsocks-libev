#
# Dockerfile for shadowsocks-libev
#

FROM alpine
MAINTAINER Vincent Gu <g@v-io.co>

ENV SS_VER 3.0.7

ENV SS_PASSWORD          password
ENV SS_METHOD            chacha20
ENV SS_TIMEOUT           600
ENV SS_INTERFACE         ""
ENV SS_LOCAL_ADDR        ""
ENV SS_UDP               true
ENV SS_DNS               8.8.4.4
ENV SS_FASTOPEN          yes
ENV SS_LOG               /dev/stderr

# define default directory
ENV APP_DIR              /srv/shadowsocks-libev
WORKDIR $APP_DIR

# build shadowsocks-libev
ENV SS_URL https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_VER/shadowsocks-libev-$SS_VER.tar.gz
ENV SS_DIR shadowsocks-libev-$SS_VER
ENV SS_DEP mbedtls libsodium udns libev pcre
ENV SS_TDEP autoconf build-base libtool linux-headers openssl-dev pcre-dev asciidoc xmlto mbedtls-dev libsodium-dev udns-dev libev-dev curl
RUN set -ex \
    && apk add --update $SS_DEP $SS_TDEP \
    && curl -sSL $SS_URL | tar xz \
    && cd $SS_DIR \
        && ./configure \
        && make install \
        && cd .. \
        && rm -rf $SS_DIR \
    && apk del --purge $SS_TDEP \
    && rm -rf /var/cache/apk/*
