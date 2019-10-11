#!/bin/sh -e

TARGET_PATH="/usr/local/bin/vlmcsd"
API_URL="https://api.github.com/repos/Wind4/vlmcsd/releases/latest"
DOWNLOAD_URL=$(curl -sSL $API_URL | grep "browser_download_url" | grep "binaries.tar.gz" | cut -d '"' -f 4)

curl -sSL $DOWNLOAD_URL | tar -zxf - -C /usr/local/bin/ binaries/Linux/intel/static/vlmcsd-x64-musl-static --strip-components 4
mv /usr/local/bin/vlmcsd-x64-musl-static $TARGET_PATH

chmod +x $TARGET_PATH
chown root:staff $TARGET_PATH
