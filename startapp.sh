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

# Enable + point Vivaldi at the CSS UI mods WITHOUT any UI clicking, by patching
# its config while it's stopped (Vivaldi rewrites these on exit, so do it here):
#   Local State  -> browser.enabled_labs_experiments += "vivaldi-css-mods@1"
#   Preferences  -> vivaldi.appearance.css_ui_mods_directory = /config/mods
# (Verified from Vivaldi source: css_mods_data_source.cc loads from that dir;
#  method mirrors csmarshall/trimvaldi.)
mkdir -p /config/profile/Default
LS="/config/profile/Local State"
PREF="/config/profile/Default/Preferences"
if [ -f "$LS" ]; then
  t=$(mktemp); jq '(.browser.enabled_labs_experiments = (((.browser.enabled_labs_experiments) // []) + ["vivaldi-css-mods@1"] | unique))' "$LS" >"$t" 2>/dev/null && mv "$t" "$LS" || rm -f "$t"
else
  printf '%s' '{"browser":{"enabled_labs_experiments":["vivaldi-css-mods@1"]}}' >"$LS"
fi
if [ -f "$PREF" ]; then
  t=$(mktemp); jq '.vivaldi.appearance.css_ui_mods_directory = "/config/mods"' "$PREF" >"$t" 2>/dev/null && mv "$t" "$PREF" || rm -f "$t"
else
  printf '%s' '{"vivaldi":{"appearance":{"css_ui_mods_directory":"/config/mods"}}}' >"$PREF"
fi

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
