#!/bin/sh
# Launch native Zen (de-branded to FoundReach in its files). Only seed the
# welcome-off prefs — no chrome CSS, no newtab override, no theming.
export HOME=/config
PROFILE=/config/profile
mkdir -p "$PROFILE"
cp -f /opt/foundreach/user.js "$PROFILE/user.js"
exec /opt/zen/zen --no-remote --profile "$PROFILE"
