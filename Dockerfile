# Zen Browser, served via noVNC over a single HTTP port (5800). Debian/glibc base.
# 100% stock Zen — no customization.
FROM jlesage/baseimage-gui:debian-12-v4

# Base-image fixes so Debian browser packages install cleanly on this minimal image:
#  - /var/log must be a real dir (dangling symlink breaks fontconfig postinst)
#  - recreate root (/etc/passwd) + root/staff groups (stripped → chown fails)
#  - block systemd/udev (their in-container postinst fails; Zen doesn't need them)
RUN { [ -d /var/log ] || { rm -f /var/log; mkdir -p /var/log; }; }; \
    grep -q '^root:'  /etc/passwd || echo 'root:x:0:0:root:/root:/bin/sh' >> /etc/passwd; \
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

# Install Zen from the official Linux x86_64 tarball.
RUN curl -fSL -o /tmp/zen.tar.xz \
      "https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz" && \
    tar -xJf /tmp/zen.tar.xz -C /opt && rm /tmp/zen.tar.xz && test -x /opt/zen/zen

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

ENV APP_NAME="Zen Browser"
EXPOSE 5800
