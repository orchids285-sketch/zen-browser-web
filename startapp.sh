#!/bin/sh
# Launch Zen inside the noVNC session. /config is the persistent HOME provided by
# the baseimage; keep a dedicated profile so it survives restarts and never locks.
export HOME=/config
mkdir -p /config/profile
exec /opt/zen/zen --no-remote --profile /config/profile
