#!/usr/bin/bash

#shellcheck disable=SC1091
source "/shim/umask.sh"
source "/shim/vpn.sh"
source "/shim/config.sh"

if [ ! -f "/config/tinyproxy.conf" ]; then
  envsubst < /tinyproxy.conf > /config/tinyproxy.conf
fi

ln -sf /config/tinyproxy.conf /app/tinyproxy/tinyproxy.conf

exec tinyproxy -d -c /app/tinyproxy/tinyproxy.conf
