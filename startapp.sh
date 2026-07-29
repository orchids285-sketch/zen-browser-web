#!/bin/sh
# Launch Zen (branded as FoundReach) inside the noVNC session. Seed our branding
# into the profile on every start (prefs + chrome CSS) without wiping user data.
export HOME=/config
PROFILE=/config/profile
mkdir -p "$PROFILE/chrome"
cp -f /opt/foundreach/user.js         "$PROFILE/user.js"
cp -f /opt/foundreach/userChrome.css  "$PROFILE/chrome/userChrome.css"
cp -f /opt/foundreach/userContent.css "$PROFILE/chrome/userContent.css"
exec /opt/zen/zen --no-remote --profile "$PROFILE"
