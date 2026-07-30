#!/bin/sh
# Launch stock Zen inside the noVNC session. No Zen customization — the only
# line here besides the launch is creating the profile DIRECTORY, without which
# Zen aborts with "Profile Missing" on a fresh container. Zen itself is untouched.
export HOME=/config
mkdir -p /config/profile
exec /opt/zen/zen --no-remote --profile /config/profile
