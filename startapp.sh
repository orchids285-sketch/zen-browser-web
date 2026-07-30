#!/bin/sh
# Launch Opera One (Chromium engine) inside the noVNC session, cleaned up:
#  - --test-type + --disable-infobars: hide the "--no-sandbox" warning bar
#  - browser.check_default_browser=false: kill the "make Opera default" prompt
export HOME=/config
mkdir -p /config/profile /config/profile/Default
rm -f /config/profile/Singleton* 2>/dev/null || true

# Suppress Opera's "make default" banner via the profile pref (Opera=Chromium prefs).
PREF="/config/profile/Default/Preferences"
if [ -f "$PREF" ]; then
  t=$(mktemp); jq '.browser.check_default_browser=false' "$PREF" >"$t" 2>/dev/null && mv "$t" "$PREF" || rm -f "$t"
else
  printf '%s' '{"browser":{"check_default_browser":false}}' >"$PREF"
fi

OPERA="$(command -v opera 2>/dev/null || echo /usr/lib/x86_64-linux-gnu/opera/opera)"
exec "$OPERA" \
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
