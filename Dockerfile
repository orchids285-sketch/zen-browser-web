# Zen Browser, served in the browser via noVNC over a single HTTP port (5800).
# Base = jlesage GUI baseimage on DEBIAN (glibc — Zen's tarball is a glibc binary,
# so Alpine/musl bases won't run it) + Xvfb + x11vnc + noVNC. Railway-native.
FROM jlesage/baseimage-gui:debian-12-v4

# Gecko/GTK runtime libs Zen needs. Two fixes for this minimal base image:
#  - recreate the standard `staff` group (gid 50) — jlesage stripped it, so
#    fontconfig-config's postinst `chown root:staff` failed and cascaded.
#  - BLOCK systemd + udev (`pkg-`): their container postinst fails (mkdir /var/log)
#    and Zen doesn't need them, so apt won't drag them in transitively.
# /var/log is a dangling symlink in this base → fontconfig's postinst can't write
# its log. Make it a real writable dir. Also repair root/staff (stripped from
# passwd/group) so postinst chowns resolve.
RUN { [ -d /var/log ] || { rm -f /var/log; mkdir -p /var/log; }; }; \
    grep -q '^root:' /etc/passwd || echo 'root:x:0:0:root:/root:/bin/sh' >> /etc/passwd; \
    grep -q '^root:'  /etc/group  || echo 'root:x:0:'  >> /etc/group; \
    grep -q '^staff:' /etc/group  || echo 'staff:x:50:' >> /etc/group; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        xz-utils curl ca-certificates \
        libgtk-3-0 libdbus-glib-1-2 libx11-xcb1 libxcb-shm0 \
        libxt6 libxtst6 libasound2 libgdk-pixbuf-2.0-0 \
        libgl1 libegl1 \
        fonts-liberation fonts-noto-color-emoji \
        systemd- udev- ; \
    dpkg --configure -a && \
    rm -rf /var/lib/apt/lists/*

# Install Zen from the official Linux x86_64 tarball (auto-latest on rebuild).
RUN curl -fSL -o /tmp/zen.tar.xz \
      "https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz" && \
    tar -xJf /tmp/zen.tar.xz -C /opt && \
    rm /tmp/zen.tar.xz && \
    test -x /opt/zen/zen

# Repoint the GUI baseimage's app launcher at Zen.
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

ENV APP_NAME="Zen Browser"
EXPOSE 5800
