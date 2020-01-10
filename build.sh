#!/bin/bash -e

CUR_DIR=$(pwd)
BUILD_DIR="$CUR_DIR/build"

ARCH="$1"
DIST_PREFIX="$CUR_DIR/dist/$ARCH"
CROSS_HOST="$ARCH-linux-gnu"

LIBEV_VER=4.27
LIBEV_URL=http://dist.schmorp.de/libev/Attic/libev-$LIBEV_VER.tar.gz

PCRE_VER=8.43
PCRE_URL=https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VER.tar.gz

C_ARES_VER=1.15.0
C_ARES_URL=https://c-ares.haxx.se/download/c-ares-$C_ARES_VER.tar.gz

MBEDTLS_VER=2.16.3
MBEDTLS_URL=https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz

SODIUM_VER=1.0.18
SODIUM_URL=https://download.libsodium.org/libsodium/releases/libsodium-$SODIUM_VER.tar.gz

SS_LIBEV_VER=3.3.4
SS_LIBEV_URL=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_LIBEV_VER/shadowsocks-libev-$SS_LIBEV_VER.tar.gz

SIMPLE_OBFS_VER=0.0.5
SIMPLE_OBFS_URL=https://github.com/shadowsocks/simple-obfs.git
SIMPLE_OBFS_HASH=486bebd9208539058e57e23a12f23103016e09b4

SOCKS5_SERVER_VER=1.9.0
SOCKS5_SERVER_URL=https://github.com/heiher/hev-socks5-server.git

UDP2RAW_VER=20190716
UDP2RAW_URL=https://github.com/wangyu-/udp2raw-tunnel.git
UDP2RAW_HASH=5cc304a26181ee17bc583b79a2e80449ea63e1b7

UDPSPEEDER_VER=20190408
UDPSPEEDER_URL=https://github.com/wangyu-/UDPspeeder.git
UDPSPEEDER_HASH=ecc90928d33741dbe726b547f2d8322540c26ea0

LIBEVENT_VER=2.1.11-stable
LIBEVENT_URL=https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VER/libevent-$LIBEVENT_VER.tar.gz

XKCPTUN_VER=20191008
XKCPTUN_URL=https://github.com/liudf0716/xkcptun.git
XKCPTUN_HASH=702180d7cf0f4d632d32910d426be598b70067b6

prepare() {
  rm -rf $BUILD_DIR && mkdir $BUILD_DIR
}

build_libev() {
  [ -d $DIST_PREFIX/libev ] && return

  cd $BUILD_DIR
  curl -sSL $LIBEV_URL | tar zxf -
  cd libev-$LIBEV_VER
  ./configure \
    --prefix="$DIST_PREFIX/libev" \
    --host="$CROSS_HOST" \
    --disable-shared \
    --enable-static \
    CFLAGS="-O3 -pipe"
  make -j$(nproc) && make install-strip
  cd $CUR_DIR
}

build_pcre() {
  [ -d $DIST_PREFIX/pcre ] && return

  cd $BUILD_DIR
  curl -sSL $PCRE_URL | tar zxf -
  cd pcre-$PCRE_VER
  ./configure \
    --prefix="$DIST_PREFIX/pcre" \
    --host="$CROSS_HOST" \
    --disable-shared \
    --enable-static \
    --enable-jit \
    --enable-utf8 \
    --enable-unicode-properties \
    CFLAGS="-O3 -pipe" \
    CXXFLAGS="-O3 -pipe"
  make -j$(nproc) && make install-strip
  cd $CUR_DIR
}

build_c_ares() {
  [ -d $DIST_PREFIX/c-ares ] && return

  cd $BUILD_DIR
  curl -sSL $C_ARES_URL | tar zxf -
  cd c-ares-$C_ARES_VER
  ./configure \
    --prefix="$DIST_PREFIX/c-ares" \
    --host="$CROSS_HOST" \
    --disable-shared \
    --enable-static \
    --disable-debug \
    CFLAGS="-O3 -pipe"
  make -j$(nproc) && make install-strip
  cd $CUR_DIR
}

build_mbedtls() {
  [ -d $DIST_PREFIX/mbedtls ] && return

  cd $BUILD_DIR
  curl -sSL $MBEDTLS_URL | tar zxf -
  cd mbedtls-$MBEDTLS_VER
  make -j$(nproc) programs \
    CC="$CROSS_HOST-gcc" \
    AR="$CROSS_HOST-ar" \
    LD="$CROSS_HOST-ld" \
    CFLAGS="-O3 -pipe"
  make install DESTDIR="$DIST_PREFIX/mbedtls"
  cd $CUR_DIR
}

build_libsodium() {
  [ -d $DIST_PREFIX/libsodium ] && return

  cd $BUILD_DIR
  curl -sSL $SODIUM_URL | tar zxf -
  cd libsodium-$SODIUM_VER
  ./configure \
    --prefix="$DIST_PREFIX/libsodium" \
    --host="$CROSS_HOST" \
    --disable-shared \
    --enable-static \
    CFLAGS="-O3 -pipe"
  make -j$(nproc) && make install-strip
  cd $CUR_DIR
}

build_shadowsocks_libev() {
  [ -d $DIST_PREFIX/shadowsocks-libev ] && return

  cd $BUILD_DIR
  curl -sSL $SS_LIBEV_URL | tar zxf -
  cd shadowsocks-libev-$SS_LIBEV_VER
  ./configure \
    --prefix="$DIST_PREFIX/shadowsocks-libev" \
    --host="$CROSS_HOST" \
    --disable-documentation \
    --disable-assert \
    --enable-static \
    --with-ev="$DIST_PREFIX/libev" \
    --with-pcre="$DIST_PREFIX/pcre" \
    --with-cares="$DIST_PREFIX/c-ares" \
    --with-mbedtls="$DIST_PREFIX/mbedtls" \
    --with-sodium="$DIST_PREFIX/libsodium" \
    LIBS="-lpthread -lm" \
    CFLAGS="-O3 -pipe" \
    LDFLAGS="-Wl,--build-id=none -Wl,-static -static -static-libgcc"
  make -j$(nproc) && make install-strip
  cd $CUR_DIR
}

build_simple_obfs() {
  [ -d $DIST_PREFIX/simple-obfs ] && return

  cd $BUILD_DIR
  git clone $SIMPLE_OBFS_URL simple-obfs-$SIMPLE_OBFS_VER
  cd simple-obfs-$SIMPLE_OBFS_VER
  git checkout $SIMPLE_OBFS_HASH
  git submodule update --init --recursive
  ./autogen.sh
  ./configure \
    --prefix="$DIST_PREFIX/simple-obfs" \
    --host="$CROSS_HOST" \
    --disable-documentation \
    --disable-assert \
    --enable-static \
    --with-ev="$DIST_PREFIX/libev" \
    LIBS="-lpthread -lm" \
    CFLAGS="-O3 -pipe" \
    LDFLAGS="-Wl,--build-id=none -Wl,-static -static -static-libgcc"
  make -j$(nproc) && make install-strip
  cd $CUR_DIR
}

build_socks5_server() {
  [ -d $DIST_PREFIX/socks5-server ] && return

  cd $BUILD_DIR
  git clone $SOCKS5_SERVER_URL --branch $SOCKS5_SERVER_VER --recursive socks5-server-$SOCKS5_SERVER_VER
  cd socks5-server-$SOCKS5_SERVER_VER
  make -j$(nproc) ENABLE_STATIC=1 CROSS_PREFIX="$CROSS_HOST-"
  make install ENABLE_STATIC=1 CROSS_PREFIX="$CROSS_HOST-" INSTDIR="$DIST_PREFIX/socks5-server" PROJECT="socks5-server"
  cd $CUR_DIR
}

build_udp2raw() {
  [ -d $DIST_PREFIX/udp2raw ] && return

  cd $BUILD_DIR
  git clone $UDP2RAW_URL udp2raw-$UDP2RAW_VER
  cd udp2raw-$UDP2RAW_VER
  git checkout $UDP2RAW_HASH

  # build
  make amd64 cc_local="$CROSS_HOST-g++" OPT="-pipe -Wl,--build-id=none"
  make amd64_hw_aes cc_local="$CROSS_HOST-g++" OPT="-pipe -Wl,--build-id=none"

  # install
  $CROSS_HOST-strip udp2raw_amd64 udp2raw_amd64_hw_aes
  install -d -m 0755 $DIST_PREFIX/udp2raw/bin
  install -m 0755 udp2raw_amd64 $DIST_PREFIX/udp2raw/bin/udp2raw
  install -m 0755 udp2raw_amd64_hw_aes $DIST_PREFIX/udp2raw/bin/udp2raw_hw_aes

  cd $CUR_DIR
}

build_udpspeeder() {
  [ -d $DIST_PREFIX/udpspeeder ] && return

  cd $BUILD_DIR
  git clone $UDPSPEEDER_URL udpspeeder-$UDPSPEEDER_VER
  cd udpspeeder-$UDPSPEEDER_VER
  git checkout $UDPSPEEDER_HASH

  # build
  make amd64 cc_local="$CROSS_HOST-g++" OPT="-pipe -Wl,--build-id=none"

  # install
  $CROSS_HOST-strip speederv2_amd64
  install -d -m 0755 $DIST_PREFIX/udpspeeder/bin
  install -m 0755 speederv2_amd64 $DIST_PREFIX/udpspeeder/bin/udpspeeder

  cd $CUR_DIR
}

build_libevent() {
  [ -d $DIST_PREFIX/libevent ] && return

  cd $BUILD_DIR
  curl -sSL $LIBEVENT_URL | tar zxf -
  cd libevent-$LIBEVENT_VER
  ./configure \
    --prefix="$DIST_PREFIX/libevent" \
    --host="$CROSS_HOST" \
    --enable-shared=no \
    --enable-static=yes \
    --disable-debug-mode \
    --disable-libevent-regress \
    --disable-samples \
    CFLAGS="-O3 -pipe"
  make -j$(nproc) && make install-strip
  cd $CUR_DIR
}

build_xkcptun() {
  [ -d $DIST_PREFIX/xkcptun ] && return

  cd $BUILD_DIR
  git clone $XKCPTUN_URL xkcptun-$XKCPTUN_VER
  cd xkcptun-$XKCPTUN_VER
  git checkout $XKCPTUN_HASH

  mkdir build && cd build
  cmake \
    -DCMAKE_INSTALL_PREFIX="$DIST_PREFIX/xkcptun" \
    -DCMAKE_C_COMPILER="$(which $CROSS_HOST-gcc)" \
    -DCMAKE_C_FLAGS="-I$DIST_PREFIX/libevent/include" \
    -DCMAKE_EXE_LINKER_FLAGS="-L$DIST_PREFIX/libevent/lib -Wl,--build-id=none" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_EXE_LINKER_FLAGS_RELEASE="-s" \
    ..
  make install

  # misc
  mv $DIST_PREFIX/xkcptun/bin/xkcp_server $DIST_PREFIX/xkcptun/bin/xkcp-server
  mv $DIST_PREFIX/xkcptun/bin/xkcp_client $DIST_PREFIX/xkcptun/bin/xkcp-client
  install -m 0755 xkcp_spy $DIST_PREFIX/xkcptun/bin/xkcp-spy

  cd $CUR_DIR
}

prepare
build_libev
build_pcre
build_c_ares
build_mbedtls
build_libsodium
build_shadowsocks_libev
build_simple_obfs
build_socks5_server
build_udp2raw
build_udpspeeder
build_libevent
build_xkcptun
