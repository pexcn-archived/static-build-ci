#!/bin/bash -e

CUR_DIR=$(pwd)
DIST_DIR="$CUR_DIR/dist"
RELEASE_DIR="$CUR_DIR/release"
VERSION=$(date +%Y%m%d)

copy_shadowsocks_libev_binary() {
  mkdir $RELEASE_DIR
  find $DIST_DIR/shadowsocks-libev -name "ss-server" -exec cp -- "{}" release \;
  find $DIST_DIR/shadowsocks-libev -name "ss-local" -exec cp -- "{}" release \;
  find $DIST_DIR/shadowsocks-libev -name "ss-redir" -exec cp -- "{}" release \;
  find $DIST_DIR/shadowsocks-libev -name "ss-tunnel" -exec cp -- "{}" release \;
  find $DIST_DIR/shadowsocks-libev -name "ss-manager" -exec cp -- "{}" release \;

  cd $RELEASE_DIR
  tar -zcvf shadowsocks-libev-$VERSION-linux-amd64.tar.gz * --remove-files
  cd $CUR_DIR
}

upload_to_github_release() {
  API_URL="https://api.github.com/repos/tcnksm/ghr/releases/latest"
  TAG=$(curl -s $API_URL | grep "tag_name" | sed -E 's/.*"([^"]+)".*/\1/')
  DOWNLOAD_URL=$(curl -s $API_URL | grep "browser_download_url" | grep "linux" | grep "amd64" | cut -d '"' -f 4)

  USER=$(echo $TRAVIS_REPO_SLUG | cut -d "/" -f 1)
  REPO=$(echo $TRAVIS_REPO_SLUG | cut -d "/" -f 2)

  curl -kLs $DOWNLOAD_URL | tar zxf - ghr_${TAG}_linux_amd64/ghr --strip-components 1

  ./ghr -t $GITHUB_TOKEN \
    -u $USER \
    -r $REPO \
    -c $TRAVIS_COMMIT \
    -n $VERSION \
    -delete \
    $VERSION release
}

copy_shadowsocks_libev_binary
upload_to_github_release
