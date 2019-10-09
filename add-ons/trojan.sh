#!/bin/bash -e

TARGET_PATH="/usr/local/bin/trojan"
API_URL="https://api.github.com/repos/trojan-gfw/trojan/releases/latest"
DOWNLOAD_URL=$(curl -sSL $API_URL | grep "browser_download_url" | grep "amd64" | grep -v "asc" | cut -d '"' -f 4)

curl -sSL $DOWNLOAD_URL | tar -Jxf - -C /usr/local/bin/ trojan/trojan --strip-components 1

chmod +x $TARGET_PATH
chown root:staff $TARGET_PATH
