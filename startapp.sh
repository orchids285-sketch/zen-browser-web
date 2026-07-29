#!/bin/sh
# Launch Zen (branded as FoundReach) inside the noVNC session. Seed our branding
# into the profile on every start (prefs + chrome CSS + new-tab extension).
export HOME=/config
PROFILE=/config/profile
mkdir -p "$PROFILE/chrome" "$PROFILE/extensions"
cp -f /opt/foundreach/user.js         "$PROFILE/user.js"
cp -f /opt/foundreach/userChrome.css  "$PROFILE/chrome/userChrome.css"
cp -f /opt/foundreach/userContent.css "$PROFILE/chrome/userContent.css"
# Install the FoundReach new-tab override extension (unpacked, id = folder name).
rm -rf "$PROFILE/extensions/newtab@foundreach.app"
cp -r /opt/foundreach/newtab-ext "$PROFILE/extensions/newtab@foundreach.app"
exec /opt/zen/zen --no-remote --profile "$PROFILE"
