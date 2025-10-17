#!/bin/sh
set -eu

[ -f ./.env ] && . ./.env

log() { echo "[$(date +'%F %T')] $*"; }

if [ -z "${DOCKER_BRIDGE:-}" ] || [ -z "${HOST_INTERFACE:-}" ]; then
  log "ERROR: DOCKER_BRIDGE and HOST_INTERFACE environment variables must be set"
  exit 1
fi

# Start MDNS
log "[+] Starting MDNS Repeater"
sh -c "exec /usr/local/sbin/mdns-repeater -f $DOCKER_BRIDGE $HOST_INTERFACE" &

sleep 2

# Start UDP Broadcast Relays
if [ -n "${UDP_PORTS:-}" ]; then
  log "[+] Relaying $UDP_PORTS"
  IFS=','; set -- $UDP_PORTS; IFS=' '
  id=1
  for port in "$@"; do
    args="--id $id --port $port"
    args="$args --dev $DOCKER_BRIDGE --dev $HOST_INTERFACE"
    [ -n "$BROADCAST_TARGET" ] && args="$args -t $BROADCAST_TARGET"
    log "[+] Starting udp-broadcast-relay-redux $args"
    sh -c "exec /usr/local/sbin/udp-broadcast-relay-redux $args" &
    id=$((id + 1))
  done
else
  log "[-] No ports specified. Bypassing udp-broadcast-relay-redux."
fi

# Wait for any process to exit
while true; do
  if ! jobs % >/dev/null 2>&1; then
    log "A child process exited; bringing container down."
    kill $(jobs -p) 2>/dev/null
    break
  fi
  sleep 1
done
wait