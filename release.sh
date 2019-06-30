#!/bin/bash -e

CUR_DIR=$(pwd)
DIST_DIR="$CUR_DIR/dist"
RELEASE_DIR="$CUR_DIR/release"
VERSION=$(date +%Y%m%d)

prepare() {
  rm -rf $RELEASE_DIR && mkdir $RELEASE_DIR
}

release() {
  for arch in $(ls $DIST_DIR)
  do
    # shadowsocks-libev
    local tmp_ss_dir=$(mktemp -d /tmp/shadowsocks-libev.XXXXXX)
    find $DIST_DIR/$arch/shadowsocks-libev -type f -name "ss-*" -print0 | xargs -0 cp -t $tmp_ss_dir
    tar -C $tmp_ss_dir -zcvf $RELEASE_DIR/shadowsocks-libev-linux-$arch-$VERSION.tar.gz $(ls -1 $tmp_ss_dir) --remove-files

    # socks5-server
    local tmp_s5_dir=$(mktemp -d /tmp/socks5-server.XXXXXX)
    find $DIST_DIR/$arch/socks5-server -type f -name "socks5-server*" -print0 | xargs -0 cp -t $tmp_s5_dir
    tar -C $tmp_s5_dir -zcvf $RELEASE_DIR/socks5-server-linux-$arch-$VERSION.tar.gz $(ls -1 $tmp_s5_dir) --remove-files
  done
}

deploy() {
  local api_url="https://api.github.com/repos/tcnksm/ghr/releases/latest"
  local download_tag=$(curl -sSL $api_url | grep "tag_name" | sed -E 's/.*"([^"]+)".*/\1/')
  local download_url=$(curl -sSL $api_url | grep "browser_download_url" | grep "linux" | grep "amd64" | cut -d '"' -f 4)

  local user=$(echo $TRAVIS_REPO_SLUG | cut -d "/" -f 1)
  local repo=$(echo $TRAVIS_REPO_SLUG | cut -d "/" -f 2)

  curl -sSL $download_url | tar -zxf - ghr_${download_tag}_linux_amd64/ghr --strip-components 1

  ./ghr -t $GITHUB_TOKEN \
    -u $user \
    -r $repo \
    -c $TRAVIS_COMMIT \
    -n $VERSION \
    -delete \
    $VERSION $RELEASE_DIR
}

prepare
release
deploy
