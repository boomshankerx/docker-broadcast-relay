# docker-broadcast-relay

Simple container combining:
- [mdns-repeater](https://github.com/geekman/mdns-repeater)
- [udp-broadcast-relay-redux](https://github.com/udp-redux/udp-broadcast-relay-redux)

This can be usefull if you are running apps like home-assistant via a docker container and would like device discovery to work correctly. 


> Requires host networking and NET_RAW/NET_ADMIN caps.

## Quick start (compose)

1. Read the docs from each of programs
2. `cp dist.env .env`
3. Identify networks / interfaces you would like to relay
4. Firewall rules may be required to enable return traffic.

## Example for TP-Link Kasa devices
```
BROADCAST_TARGET=
DOCKER_BRIDGE=br-4e9e4071aa6e
HOST_INTERFACE=ens18
UDP_PORTS=9999,20002
```

```bash
docker compose up -d
```