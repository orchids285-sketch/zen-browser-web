#!/bin/sh
# Launch stock Zen inside the noVNC session. Only seed the welcome-off prefs.
export HOME=/config
PROFILE=/config/profile
mkdir -p "$PROFILE"
cp -f /opt/foundreach/user.js "$PROFILE/user.js"
exec /opt/zen/zen --no-remote --profile "$PROFILE"
