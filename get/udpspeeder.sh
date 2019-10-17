#!/bin/bash -e

TARGET_PATH="/usr/local/bin/udpspeeder"
API_URL="https://api.github.com/repos/pexcn/static-build-ci/releases/latest"
DOWNLOAD_URL=$(curl -sSL $API_URL | grep "browser_download_url" | grep "udpspeeder" | grep "linux" | grep "x86_64" | cut -d '"' -f 4)

curl -sSL $DOWNLOAD_URL | tar -zxf - -C /usr/local/bin/ udpspeeder

chmod +x $TARGET_PATH
chown root:staff $TARGET_PATH
