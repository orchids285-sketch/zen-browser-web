#!/bin/sh
# Launch stock Zen inside the noVNC session. No customization.
export HOME=/config
exec /opt/zen/zen --no-remote --profile /config/profile
