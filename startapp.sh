#!/bin/sh
# Launch Vivaldi (Chromium engine) inside the noVNC session.
export HOME=/config
mkdir -p /config/profile
exec /opt/vivaldi/vivaldi \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --no-first-run \
  --no-default-browser-check \
  --disable-features=Translate \
  --password-store=basic \
  --start-maximized \
  --user-data-dir=/config/profile
