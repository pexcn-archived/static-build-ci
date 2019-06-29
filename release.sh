#!/bin/bash -e

CUR_DIR=$(pwd)
DIST_DIR="$CUR_DIR/dist"
RELEASE_DIR="$CUR_DIR/release"

prepare() {
  rm -rf $RELEASE_DIR && mkdir $RELEASE_DIR
}

tarball_bin() {
  for arch in $(ls $DIST_DIR)
  do
    # ss-libev
    local tmp_ss_dir=$(mktemp -d /tmp/shadowsocks-libev.XXXXXX)
    find $DIST_DIR/$arch/shadowsocks-libev -type f -name "ss-*" -print0 | xargs -0 cp -t $tmp_ss_dir
    tar -C $tmp_ss_dir -zcvf $RELEASE_DIR/shadowsocks-libev-linux-$arch-$VERSION.tar.gz $(ls -1 $tmp_ss_dir) --remove-files

    # socks5-server
    local tmp_s5_dir=$(mktemp -d /tmp/socks5-server.XXXXXX)
    find $DIST_DIR/$arch/socks5-server -type f -name "socks5-server*" -print0 | xargs -0 cp -t $tmp_s5_dir
    tar -C $tmp_s5_dir -zcvf $RELEASE_DIR/socks5-server-linux-$arch-$VERSION.tar.gz $(ls -1 $tmp_s5_dir) --remove-files

    # vlmcsd
    local tmp_vlmcsd_dir=$(mktemp -d /tmp/vlmcsd.XXXXXX)
    find $DIST_DIR/$arch/vlmcsd -type f -name "vlmcs*" -print0 | xargs -0 cp -t $tmp_vlmcsd_dir
    tar -C $tmp_vlmcsd_dir -zcvf $RELEASE_DIR/vlmcsd-linux-$arch-$VERSION.tar.gz $(ls -1 $tmp_vlmcsd_dir) --remove-files
  done
}

prepare
tarball_bin
