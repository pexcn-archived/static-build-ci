#!/bin/bash -e

LIBEV_VER=4.25
LIBEV_URL=http://dist.schmorp.de/libev/Attic/libev-$LIBEV_VER.tar.gz
PCRE_VER=8.43
PCRE_URL=https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VER.tar.gz
C_ARES_VER=1.15.0
C_ARES_URL=https://c-ares.haxx.se/download/c-ares-$C_ARES_VER.tar.gz
MBEDTLS_VER=2.16.0
MBEDTLS_URL=https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
SODIUM_VER=1.0.17
SODIUM_URL=https://github.com/jedisct1/libsodium/releases/download/$SODIUM_VER/libsodium-$SODIUM_VER.tar.gz
SS_LIBEV_VER=3.2.5
SS_LIBEV_URL=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_LIBEV_VER/shadowsocks-libev-$SS_LIBEV_VER.tar.gz

CUR_DIR=$(pwd)
DIST_PREFIX="$CUR_DIR/dist"
CROSS_HOST="$1"

prepare() {
  rm -rf $CUR_DIR/build && mkdir $CUR_DIR/build
}

build_libev() {
  [ -d $DIST_PREFIX/libev ] && return

  cd $CUR_DIR/build
  curl -kLs $LIBEV_URL | tar zxf -
  cd libev-$LIBEV_VER
  ./configure \
    --prefix="$DIST_PREFIX/libev" \
    --host="$CROSS_HOST" \
    --disable-shared \
    --enable-static
  make -j`nproc` && make install-strip
  cd $CUR_DIR
}

build_pcre() {
  [ -d $DIST_PREFIX/pcre ] && return

  cd $CUR_DIR/build
  curl -kLs $PCRE_URL | tar zxf -
  cd pcre-$PCRE_VER
  ./configure \
    --prefix="$DIST_PREFIX/pcre" \
    --host="$CROSS_HOST" \
    --disable-shared \
    --enable-static \
    --enable-jit \
    --enable-utf8 \
    --enable-unicode-properties
  make -j`nproc` && make install-strip
  cd $CUR_DIR
}

build_c_ares() {
  [ -d $DIST_PREFIX/c-ares ] && return

  cd $CUR_DIR/build
  curl -kLs $C_ARES_URL | tar zxf -
  cd c-ares-$C_ARES_VER
  ./configure \
    --prefix="$DIST_PREFIX/c-ares" \
    --host="$CROSS_HOST" \
    --disable-shared \
    --enable-static \
    --enable-optimize="-O3" \
    --disable-debug
  make -j`nproc` && make install-strip
  cd $CUR_DIR
}

build_mbedtls() {
  [ -d $DIST_PREFIX/mbedtls ] && return

  cd $CUR_DIR/build
  curl -kLs $MBEDTLS_URL | tar zxf -
  cd mbedtls-$MBEDTLS_VER
  make -j`nproc` programs \
    CC="$CROSS_HOST-gcc" \
    AR="$CROSS_HOST-ar" \
    LD="$CROSS_HOST-ld" \
    CFLAGS="-O3" \
    LDFLAGS=-static
  make install DESTDIR="$DIST_PREFIX/mbedtls"
  cd $CUR_DIR
}

build_libsodium() {
  [ -d $DIST_PREFIX/libsodium ] && return

  cd $CUR_DIR/build
  curl -kLs $SODIUM_URL | tar zxf -
  cd libsodium-$SODIUM_VER
  ./configure \
    --prefix="$DIST_PREFIX/libsodium" \
    --host="$CROSS_HOST" \
    --disable-shared \
    --enable-static \
    --enable-opt
  make -j`nproc` && make install-strip
  cd $CUR_DIR
}

build_shadowsocks_libev() {
  [ -d $DIST_PREFIX/shadowsocks-libev ] && return

  cd $CUR_DIR/build
  curl -kLs $SS_LIBEV_URL | tar zxf -
  cd shadowsocks-libev-$SS_LIBEV_VER
  ./configure \
    --prefix="$DIST_PREFIX/shadowsocks-libev" \
    --host="$CROSS_HOST" \
    --enable-static \
    --disable-documentation \
    --disable-assert \
    --with-ev="$DIST_PREFIX/libev" \
    --with-pcre="$DIST_PREFIX/pcre" \
    --with-cares="$DIST_PREFIX/c-ares" \
    --with-mbedtls="$DIST_PREFIX/mbedtls" \
    --with-sodium="$DIST_PREFIX/libsodium" \
    LIBS="-lpthread -lm" \
    LDFLAGS="-Wl,-static -static -static-libgcc"
  make -j`nproc` && make install-strip
  cd $CUR_DIR
}

prepare
build_libev
build_pcre
build_c_ares
build_mbedtls
build_libsodium
build_shadowsocks_libev
