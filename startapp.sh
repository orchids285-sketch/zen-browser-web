#!/bin/sh
# Launch Vivaldi (Chromium engine) inside the noVNC session.
export HOME=/config
mkdir -p /config/profile
# Clear stale Chromium singleton locks from an unclean shutdown. Without this,
# on a persistent volume Vivaldi aborts with "profile appears to be in use by
# another process" (exit 21) and the container dies + crash-loops. Safe every
# boot (single-instance container); does NOT touch profile settings.
rm -f /config/profile/Singleton* 2>/dev/null || true
# Refresh the Dia-like CSS mods each boot (folder is set once in Vivaldi settings
# to /config/mods; updating the image updates the CSS without re-configuring).
mkdir -p /config/mods
cp -f /opt/mods/*.css /config/mods/ 2>/dev/null || true
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
