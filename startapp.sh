#!/bin/sh
# Launch Chromium inside the noVNC session. Container-friendly flags:
# no-sandbox (container has no setuid sandbox), disable-dev-shm (small /dev/shm),
# basic password store (no keyring prompt), persistent profile under /config.
export HOME=/config
mkdir -p /config/profile
exec /usr/bin/chromium \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --no-first-run \
  --no-default-browser-check \
  --password-store=basic \
  --start-maximized \
  --user-data-dir=/config/profile
