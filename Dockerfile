# Vivaldi (Chromium/Blink engine) served in-browser via noVNC over one HTTP port
# (5800). User wants a Chromium-engine browser "like Dia" but with a Zen-style
# vertical sidebar + Workspaces — Vivaldi is the closest deployable match.
# Base = jlesage GUI baseimage on DEBIAN (glibc) + Xvfb + x11vnc + noVNC.
FROM jlesage/baseimage-gui:debian-12-v4

# Base-image repairs so Debian browser packages install cleanly on this minimal
# image (same fixes proven with the Zen build):
#  - /var/log is a dangling symlink -> make it a real writable dir (fontconfig postinst)
#  - recreate root + staff (stripped from passwd/group) so postinst chowns resolve
#  - BLOCK systemd + udev (`pkg-`): their in-container postinst fails; not needed
RUN { [ -d /var/log ] || { rm -f /var/log; mkdir -p /var/log; }; }; \
    grep -q '^root:'  /etc/passwd || echo 'root:x:0:0:root:/root:/bin/sh' >> /etc/passwd; \
    grep -q '^root:'  /etc/group  || echo 'root:x:0:'  >> /etc/group; \
    grep -q '^staff:' /etc/group  || echo 'staff:x:50:' >> /etc/group; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg \
      fonts-liberation fonts-noto-color-emoji \
      systemd- udev- && \
    dpkg --configure -a && \
    rm -rf /var/lib/apt/lists/*

# Install Vivaldi from its official APT repo (auto-latest stable). apt resolves
# all Chromium runtime Depends (libnss3, libgbm1, libasound2, ...) automatically.
RUN curl -fSL https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/vivaldi.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/vivaldi.gpg arch=amd64] https://repo.vivaldi.com/archive/deb/ stable main" > /etc/apt/sources.list.d/vivaldi.list && \
    apt-get update && \
    apt-get install -y vivaldi-stable && \
    rm -rf /var/lib/apt/lists/* && \
    test -x /opt/vivaldi/vivaldi

# Dia-like UI CSS mods (VivalArc Arc layout + FoundReach warm palette). startapp
# copies these into the profile's mods folder on boot; Vivaldi loads them once
# "Allow CSS modifications" is on and the folder is set to /config/mods.
COPY mods/ /opt/mods/

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

# noVNC window / page title (neutral — not a rebrand of Vivaldi itself).
ENV APP_NAME="Browser"
# If Vivaldi ever exits/crashes, restart it instead of shutting the container
# down (jlesage default kills the container when the app exits → crash-loop).
ENV KEEP_APP_RUNNING=1
EXPOSE 5800
