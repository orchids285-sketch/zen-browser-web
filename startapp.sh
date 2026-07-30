#!/bin/sh
# Launch Google Chrome (Chromium engine) inside the noVNC session, cleaned up:
#  - --test-type + --disable-infobars: hide the "--no-sandbox" warning bar
export HOME=/config
mkdir -p /config/profile
rm -f /config/profile/Singleton* 2>/dev/null || true

CHROME="$(command -v google-chrome-stable 2>/dev/null || command -v google-chrome 2>/dev/null || echo /usr/bin/google-chrome-stable)"
exec "$CHROME" \
  --no-sandbox \
  --test-type \
  --disable-infobars \
  --disable-dev-shm-usage \
  --disable-gpu \
  --no-first-run \
  --no-default-browser-check \
  --password-store=basic \
  --start-maximized \
  --user-data-dir=/config/profile
