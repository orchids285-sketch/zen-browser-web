#!/bin/sh
# Launch stock Zen inside the noVNC session. No customization — just ensure the
# profile dir exists (Zen errors "Profile Missing" if the --profile path is absent).
export HOME=/config
mkdir -p /config/profile
exec /opt/zen/zen --no-remote --profile /config/profile
