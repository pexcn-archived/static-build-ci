#!/bin/bash -e

LIBEV_VERSION=4.25
PCRE_VERSION=8.43
CARES_VERSION=1.15.0
MBEDTLS_VERSION=2.16.0
LIBSODIUM_VERSION=1.0.17

CUR_DIR=$(pwd)
PREFIX_DIR="$CUR_DIR/dist"
BUILD_HOST="x86_64"

prepare() {
  rm -rf $CUR_DIR/build && mkdir $CUR_DIR/build
}

build_libev() {
  [ -d $PREFIX_DIR/libev ] && return

  cd $CUR_DIR/build
  curl -kLs http://dist.schmorp.de/libev/libev-$LIBEV_VERSION.tar.gz | tar zxf -
  cd libev-$LIBEV_VERSION
  ./configure --prefix="$PREFIX_DIR/libev" --host="$BUILD_HOST" --disable-shared --enable-static
  make -j`nproc` && make install
  cd $CUR_DIR
}

build_pcre() {
  [ -d $PREFIX_DIR/pcre ] && return

  cd $CUR_DIR/build
  curl -kLs https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VERSION.tar.gz | tar zxf -
  cd pcre-$PCRE_VERSION
  ./configure --prefix="$PREFIX_DIR/pcre" --host="$BUILD_HOST" --disable-shared --enable-static \
    --enable-jit --enable-utf8 --enable-unicode-properties
  make -j`nproc` && make install
  cd $CUR_DIR
}

build_cares() {
  [ -d $PREFIX_DIR/c-ares ] && return

  cd $CUR_DIR/build
  curl -kLs https://c-ares.haxx.se/download/c-ares-$CARES_VERSION.tar.gz | tar zxf -
  cd c-ares-$CARES_VERSION
  ./configure --prefix="$PREFIX_DIR/c-ares" --host="$BUILD_HOST" --disable-shared --enable-static \
    --enable-optimize="-O3" --disable-debug
  make -j`nproc` && make install
  cd $CUR_DIR
}

build_mbedtls() {
  [ -d $PREFIX_DIR/mbedtls ] && return

  cd $CUR_DIR/build
  curl -kLs https://tls.mbed.org/download/mbedtls-$MBEDTLS_VERSION-gpl.tgz | tar zxf -
  cd mbedtls-$MBEDTLS_VERSION
  make -j`nproc` programs CFLAGS="-O3 -fPIC" LDFLAGS=-static \
    CC="$BUILD_HOST-linux-gnu-gcc" AR="$BUILD_HOST-linux-gnu-ar" LD="$BUILD_HOST-linux-gnu-ld"
  make install DESTDIR="$PREFIX_DIR/mbedtls"
  cd $CUR_DIR
}

build_libsodium() {
  [ -d $PREFIX_DIR/libsodium ] && return

  cd $CUR_DIR/build
  curl -kLs https://github.com/jedisct1/libsodium/releases/download/$LIBSODIUM_VERSION/libsodium-$LIBSODIUM_VERSION.tar.gz | tar zxf -
  cd libsodium-$LIBSODIUM_VERSION
  ./configure --prefix="$PREFIX_DIR/libsodium" --host="$BUILD_HOST" --disable-shared --enable-static \
    --enable-opt
  make -j`nproc` && make install
  cd $CUR_DIR
}

prepare
build_libev
build_pcre
build_cares
build_mbedtls
build_libsodium
