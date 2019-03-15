#!/bin/bash -e

LIBEV_VER=4.25
LIBEV_URL=http://dist.schmorp.de/libev/Attic/libev-$LIBEV_VER.tar.gz
PCRE_VER=8.43
PCRE_URL=https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VER.tar.gz
C_ARES_VER=1.15.0
C_ARES_URL=https://c-ares.haxx.se/download/c-ares-$C_ARES_VER.tar.gz
MBEDTLS_VER=2.16.0
MBEDTLS_URL=https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
LIBSODIUM_VER=1.0.17
LIBSODIUM_URL=https://github.com/jedisct1/libsodium/releases/download/$LIBSODIUM_VER/libsodium-$LIBSODIUM_VER.tar.gz
SHADOWSOCKS_LIBEV_VER=3.2.5
SHADOWSOCKS_LIBEV_URL=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SHADOWSOCKS_LIBEV_VER/shadowsocks-libev-$SHADOWSOCKS_LIBEV_VER.tar.gz

CUR_DIR=$(pwd)
PREFIX="$CUR_DIR/dist"
HOST="x86_64-linux-gnu"

prepare() {
  rm -rf $CUR_DIR/build && mkdir $CUR_DIR/build
}

build_libev() {
  [ -d $PREFIX/libev ] && return

  cd $CUR_DIR/build
  curl -kLs $LIBEV_URL | tar zxf -
  cd libev-$LIBEV_VER
  ./configure --prefix="$PREFIX/libev" --host="$HOST" --disable-shared --enable-static
  make -j`nproc` && make install-strip
  cd $CUR_DIR
}

build_pcre() {
  [ -d $PREFIX/pcre ] && return

  cd $CUR_DIR/build
  curl -kLs $PCRE_URL | tar zxf -
  cd pcre-$PCRE_VER
  ./configure --prefix="$PREFIX/pcre" --host="$HOST" --disable-shared --enable-static \
    --enable-jit --enable-utf8 --enable-unicode-properties
  make -j`nproc` && make install-strip
  cd $CUR_DIR
}

build_c_ares() {
  [ -d $PREFIX/c-ares ] && return

  cd $CUR_DIR/build
  curl -kLs $C_ARES_URL | tar zxf -
  cd c-ares-$C_ARES_VER
  ./configure --prefix="$PREFIX/c-ares" --host="$HOST" --disable-shared --enable-static \
    --enable-optimize="-O3" --disable-debug
  make -j`nproc` && make install-strip
  cd $CUR_DIR
}

build_mbedtls() {
  [ -d $PREFIX/mbedtls ] && return

  cd $CUR_DIR/build
  curl -kLs $MBEDTLS_URL | tar zxf -
  cd mbedtls-$MBEDTLS_VER
  make -j`nproc` programs CC="$HOST-gcc" AR="$HOST-ar" LD="$HOST-ld" CFLAGS="-O3" LDFLAGS=-static
  make install DESTDIR="$PREFIX/mbedtls"
  cd $CUR_DIR
}

build_libsodium() {
  [ -d $PREFIX/libsodium ] && return

  cd $CUR_DIR/build
  curl -kLs $LIBSODIUM_URL | tar zxf -
  cd libsodium-$LIBSODIUM_VER
  ./configure --prefix="$PREFIX/libsodium" --host="$HOST" --disable-shared --enable-static \
    --enable-opt
  make -j`nproc` && make install-strip
  cd $CUR_DIR
}

build_shadowsocks_libev() {
  [ -d $PREFIX/shadowsocks-libev ] && return

  cd $CUR_DIR/build
  curl -kLs $SHADOWSOCKS_LIBEV_URL | tar zxf -
  cd shadowsocks-libev-$SHADOWSOCKS_LIBEV_VER
  ./configure --prefix="$PREFIX/shadowsocks-libev" --host="$HOST" --enable-static \
    --disable-documentation --disable-assert \
    --with-ev="$PREFIX/libev" --with-pcre="$PREFIX/pcre" --with-cares="$PREFIX/c-ares" --with-mbedtls="$PREFIX/mbedtls" --with-sodium="$PREFIX/libsodium" \
    LIBS="-lpthread -lm" \
    CFLAGS="-I$PREFIX/libev/include -I$PREFIX/pcre/include -I$PREFIX/c-ares/include -I$PREFIX/mbedtls/include -I$PREFIX/libsodium/include" \
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
