# docker-broadcast-relay (Alpine)

Single container bundling:
- [mdns-repeater](https://github.com/geekman/mdns-repeater)
- [udp-broadcast-relay-redux](https://github.com/udp-redux/udp-broadcast-relay-redux)

> Requires host networking and NET_RAW/NET_ADMIN caps.

## Quick start (compose)

1. Read the docs from each of programs
2. Modify compose.yml
3. Firewall rules may be required to enable return traffic

```
MDNS_INTERFACES: <DOCKER_BRIDGE> <HOST_INTERFACE>
MDNS_FLAGS: -f
RELAY_CONFIG: > 
    id=1 port=<PORT> devs=<DOCKER_BRIDGE>,<HOST_INTERFACE> [multicast=<IP>] [spoof=<IP>];
    id=2 port=<PORT> devs=<DOCKER_BRIDGE>,<HOST_INTERFACE> [multicast=<IP>] [spoof=<IP>];

```

```bash
docker compose up -d
```