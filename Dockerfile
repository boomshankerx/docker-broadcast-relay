# docker-broadcast-relay – Alpine, multi-stage

ARG ALPINE_VER=3.20

# ---- udp-broadcast-relay-redux build ----
FROM alpine:${ALPINE_VER} AS relay-build
RUN apk update
RUN apk add --no-cache build-base git linux-headers
WORKDIR /src
RUN git clone --depth=1 https://github.com/udp-redux/udp-broadcast-relay-redux.git .
RUN make && strip udp-broadcast-relay-redux

# ---- mdns-repeater build ----
FROM alpine:${ALPINE_VER} AS mdns-build
RUN apk update
RUN apk add --no-cache build-base git linux-headers
WORKDIR /src
RUN git clone --depth=1 https://github.com/geekman/mdns-repeater.git . \
    && make \
    && strip mdns-repeater

# ---- final runtime ----
FROM alpine:${ALPINE_VER}
RUN apk add --no-cache dumb-init
COPY --from=relay-build /src/udp-broadcast-relay-redux /usr/local/sbin/udp-broadcast-relay-redux
COPY --from=mdns-build /src/mdns-repeater /usr/local/sbin/mdns-repeater

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV BROADCAST_TARGET="" \
    DOCKER_BRIDGE="" \
    HOST_INTERFACE="" \
    UDP_PORTS="" 

ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD ["/entrypoint.sh"]