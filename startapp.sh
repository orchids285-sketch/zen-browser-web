#!/bin/sh
# Launch Opera One (Chromium engine) inside the noVNC session.
export HOME=/config
mkdir -p /config/profile
# Clear stale Chromium singleton locks from an unclean shutdown, else the browser
# aborts "profile in use" and the container crash-loops.
rm -f /config/profile/Singleton* 2>/dev/null || true

# Opera resolves to /usr/bin/opera (wrapper) or the lib path.
OPERA="$(command -v opera 2>/dev/null || echo /usr/lib/x86_64-linux-gnu/opera/opera)"
exec "$OPERA" \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --no-first-run \
  --no-default-browser-check \
  --password-store=basic \
  --start-maximized \
  --user-data-dir=/config/profile
