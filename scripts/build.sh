#!/usr/bin/env bash
set -euo pipefail

if [[ EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

cd ~
git clone https://github.com/geekman/mdns-repeater.git --depth=1
git clone https://github.com/udp-redux/udp-broadcast-relay-redux.git --depth=1

(
    cd mdns-repeater
    make
    cp mdns-repeater /usr/local/sbin/mdns-repeater
)

(
    cd udp-broadcast-relay-redux
    make
    cp udp-broadcast-relay-redux /usr/local/sbin/udp-broadcast-relay-redux
)

