# Static Build CI

[![Build Status](https://travis-ci.org/pexcn/static-build-ci.svg?branch=master)](https://travis-ci.org/pexcn/static-build-ci)
[![GitHub Releases](https://img.shields.io/github/downloads/pexcn/static-build-ci/total.svg)](https://github.com/pexcn/static-build-ci/releases)

Static Build CI is a bash shell script, it can be automatically statically compiled some programs via continuous integration and automatically deployed to [GitHub release page](https://github.com/pexcn/static-build-ci/releases).  

Now supports the following programs:

- [x] [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev)
- [x] [hev-socks5-server](https://github.com/heiher/hev-socks5-server)
- [x] add-ons
  - [x] [mtg](https://github.com/9seconds/mtg)
  - [x] [trojan](https://github.com/trojan-gfw/trojan)
  - [x] [vlmcsd](https://github.com/Wind4/vlmcsd)

## Usage

```bash
API_URL="https://api.github.com/repos/pexcn/static-build-ci/releases/latest"

# shadowsocks-libev
SS_LIBEV_URL=$(curl -sSL $API_URL | grep "browser_download_url" | grep "shadowsocks-libev" | grep "linux" | grep "x86_64" | cut -d '"' -f 4)
curl -sSL $SS_LIBEV_URL | tar -zvxf - -C /usr/local/bin/ ss-server

# socks5-server
SOCKS5_SERVER_URL=$(curl -sSL $API_URL | grep "browser_download_url" | grep "socks5-server" | grep "linux" | grep "x86_64" | cut -d '"' -f 4)
curl -sSL $SOCKS5_SERVER_URL | tar -zvxf - -C /usr/local/bin/ socks5-server
```

### Add-ons

Note: Install linux amd64(x86_64) version only.

```bash
# mtg
curl -sSL https://github.com/pexcn/static-build-ci/raw/master/add-ons/mtg.sh | bash
# trojan
curl -sSL https://github.com/pexcn/static-build-ci/raw/master/add-ons/trojan.sh | bash
# vlmcsd
curl -sSL https://github.com/pexcn/static-build-ci/raw/master/add-ons/vlmcsd.sh | bash
```

It can be combined with [systemd-services](https://github.com/pexcn/systemd-services).

## License

```
Copyright (C) 2019, pexcn <i@pexcn.me>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
