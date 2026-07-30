# Chromium (Blink engine — same base as Dia/Arc), served in the browser via noVNC
# over a single HTTP port (5800). jlesage GUI baseimage on Debian + Xvfb/noVNC.
FROM jlesage/baseimage-gui:debian-12-v4

# Base-image fixes so Debian browser packages install cleanly on this minimal image
# (dangling /var/log symlink; stripped root/staff in passwd/group; block systemd/udev
# whose in-container postinst fails), then install Chromium + fonts.
RUN { [ -d /var/log ] || { rm -f /var/log; mkdir -p /var/log; }; }; \
    grep -q '^root:'  /etc/passwd || echo 'root:x:0:0:root:/root:/bin/sh' >> /etc/passwd; \
    grep -q '^root:'  /etc/group  || echo 'root:x:0:'  >> /etc/group; \
    grep -q '^staff:' /etc/group  || echo 'staff:x:50:' >> /etc/group; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        chromium \
        fonts-liberation fonts-noto-color-emoji \
        systemd- udev- ; \
    dpkg --configure -a && \
    rm -rf /var/lib/apt/lists/*

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

ENV APP_NAME="FoundReach"
EXPOSE 5800
