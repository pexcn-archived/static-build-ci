#!/bin/bash -e

CUR_DIR=$(pwd)
BUILD_DIR="$CUR_DIR/build"

ARCH="$1"
DIST_PREFIX="$CUR_DIR/dist/$ARCH"
CROSS_HOST="$ARCH-linux-gnu"

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

SOCKS5_SERVER_VER=1.7.3
SOCKS5_SERVER_URL=https://github.com/heiher/hev-socks5-server.git

prepare() {
  rm -rf $BUILD_DIR && mkdir $BUILD_DIR
}

build_libev() {
  [ -d $DIST_PREFIX/libev ] && return

  cd $BUILD_DIR
  curl -Ls $LIBEV_URL | tar zxf -
  cd libev-$LIBEV_VER
  ./configure \
    --prefix="$DIST_PREFIX/libev" \
    --host="$CROSS_HOST" \
    --disable-shared \
    --enable-static \
    CFLAGS="-O3 -pipe"
  make -j`nproc` && make install-strip
  cd $CUR_DIR
}

build_pcre() {
  [ -d $DIST_PREFIX/pcre ] && return

  cd $BUILD_DIR
  curl -Ls $PCRE_URL | tar zxf -
  cd pcre-$PCRE_VER
  ./configure \
    --prefix="$DIST_PREFIX/pcre" \
    --host="$CROSS_HOST" \
    --disable-shared \
    --enable-static \
    --enable-jit \
    --enable-utf8 \
    --enable-unicode-properties \
    CFLAGS="-O3 -pipe"
  make -j`nproc` && make install-strip
  cd $CUR_DIR
}

build_c_ares() {
  [ -d $DIST_PREFIX/c-ares ] && return

  cd $BUILD_DIR
  curl -Ls $C_ARES_URL | tar zxf -
  cd c-ares-$C_ARES_VER
  ./configure \
    --prefix="$DIST_PREFIX/c-ares" \
    --host="$CROSS_HOST" \
    --disable-shared \
    --enable-static \
    --disable-debug \
    CFLAGS="-O3 -pipe"
  make -j`nproc` && make install-strip
  cd $CUR_DIR
}

build_mbedtls() {
  [ -d $DIST_PREFIX/mbedtls ] && return

  cd $BUILD_DIR
  curl -Ls $MBEDTLS_URL | tar zxf -
  cd mbedtls-$MBEDTLS_VER
  make -j`nproc` programs \
    CC="$CROSS_HOST-gcc" \
    AR="$CROSS_HOST-ar" \
    LD="$CROSS_HOST-ld" \
    CFLAGS="-O3 -pipe" \
    LDFLAGS=-static
  make install DESTDIR="$DIST_PREFIX/mbedtls"
  cd $CUR_DIR
}

build_libsodium() {
  [ -d $DIST_PREFIX/libsodium ] && return

  cd $BUILD_DIR
  curl -Ls $SODIUM_URL | tar zxf -
  cd libsodium-$SODIUM_VER
  ./configure \
    --prefix="$DIST_PREFIX/libsodium" \
    --host="$CROSS_HOST" \
    --disable-shared \
    --enable-static \
    CFLAGS="-O3 -pipe"
  make -j`nproc` && make install-strip
  cd $CUR_DIR
}

build_shadowsocks_libev() {
  [ -d $DIST_PREFIX/shadowsocks-libev ] && return

  cd $BUILD_DIR
  curl -Ls $SS_LIBEV_URL | tar zxf -
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
    CFLAGS="-O3 -pipe" \
    LDFLAGS="-Wl,-static -static -static-libgcc"
  make -j`nproc` && make install-strip
  cd $CUR_DIR
}

build_socks5_server() {
  [ -d $DIST_PREFIX/socks5-server ] && return

  cd $BUILD_DIR
  git clone $SOCKS5_SERVER_URL --branch $SOCKS5_SERVER_VER --recursive socks5-server-$SOCKS5_SERVER_VER
  cd socks5-server-$SOCKS5_SERVER_VER
  make -j`nproc` ENABLE_STATIC=1 CROSS_PREFIX="$CROSS_HOST-"
  make install ENABLE_STATIC=1 CROSS_PREFIX="$CROSS_HOST-" INSTDIR="$DIST_PREFIX/socks5-server" PROJECT="socks5-server"
  cd $CUR_DIR
}

prepare
build_libev
build_pcre
build_c_ares
build_mbedtls
build_libsodium
build_shadowsocks_libev
build_socks5_server
