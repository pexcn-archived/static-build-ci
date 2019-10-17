#!/bin/bash -e

TARGET_PATH="/usr/local/bin/udp2raw"
API_URL="https://api.github.com/repos/pexcn/static-build-ci/releases/latest"
DOWNLOAD_URL=$(curl -sSL $API_URL | grep "browser_download_url" | grep "udp2raw" | grep "linux" | grep "x86_64" | cut -d '"' -f 4)

get_extract_name() {
  local aes_support=$(cat /proc/cpuinfo | grep "aes")

  if [ -z "$aes_support" ]; then
    echo "udp2raw"
  else
    echo "udp2raw_hw_aes"
  fi
}

curl -sSL $DOWNLOAD_URL | tar -zxf - -C /usr/local/bin/ $(get_extract_name)
mv /usr/local/bin/$(get_extract_name) $TARGET_PATH

chmod +x $TARGET_PATH
chown root:staff $TARGET_PATH
