#!/bin/bash -e

TARGET_PATH="/usr/local/bin/mtg"

API_URL="https://api.github.com/repos/9seconds/mtg/releases/latest"
DOWNLOAD_URL=$(curl -sSL $API_URL | grep "browser_download_url" | grep "linux" | grep "amd64" | cut -d '"' -f 4)

curl -sSL $DOWNLOAD_URL --create-dirs -o $TARGET_PATH
chmod +x $TARGET_PATH
