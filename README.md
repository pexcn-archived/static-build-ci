# Static Build CI

[![Build Status](https://travis-ci.org/pexcn/static-build-ci.svg?branch=master)](https://travis-ci.org/pexcn/static-build-ci)
[![GitHub Releases](https://img.shields.io/github/downloads/pexcn/static-build-ci/total.svg)](https://github.com/pexcn/static-build-ci/releases)

Static Build CI is a bash shell script, it can be automatically statically compiled some programs via continuous integration and automatically deployed to [GitHub release page](https://github.com/pexcn/static-build-ci/releases).  

Now supports the following programs:

- [x] [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev)
- [x] [simple-obfs](https://github.com/shadowsocks/simple-obfs)
- [x] [hev-socks5-server](https://github.com/heiher/hev-socks5-server)
- [x] [mtg](https://github.com/9seconds/mtg)
- [x] [trojan](https://github.com/trojan-gfw/trojan)
- [x] [udp2raw](https://github.com/wangyu-/udp2raw-tunnel)
- [x] [udpspeeder](https://github.com/wangyu-/UDPspeeder)
- [x] [vlmcsd](https://github.com/Wind4/vlmcsd)
- [x] [chisel](https://github.com/jpillora/chisel)

## Usage

Install linux amd64 (x86_64) version only, it can be combined with [systemd-services](https://github.com/pexcn/systemd-services).

```bash
# ss-server
curl -sSL https://github.com/pexcn/static-build-ci/raw/master/get/ss-server.sh | bash
# obfs-server
curl -sSL https://github.com/pexcn/static-build-ci/raw/master/get/obfs-server.sh | bash
# socks5-server
curl -sSL https://github.com/pexcn/static-build-ci/raw/master/get/socks5-server.sh | bash
# mtg
curl -sSL https://github.com/pexcn/static-build-ci/raw/master/get/mtg.sh | bash
# trojan
curl -sSL https://github.com/pexcn/static-build-ci/raw/master/get/trojan.sh | bash
# udp2raw
curl -sSL https://github.com/pexcn/static-build-ci/raw/master/get/udp2raw.sh | bash
# udpspeeder
curl -sSL https://github.com/pexcn/static-build-ci/raw/master/get/udpspeeder.sh | bash
# vlmcsd
curl -sSL https://github.com/pexcn/static-build-ci/raw/master/get/vlmcsd.sh | bash
# chisel
curl -sSL https://github.com/pexcn/static-build-ci/raw/master/get/chisel.sh | bash
```

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
