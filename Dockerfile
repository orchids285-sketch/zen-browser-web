# Zen Browser, served in the browser via noVNC over a single HTTP port (5800).
# Built on jlesage's GUI baseimage (Debian/glibc + Xvfb + x11vnc + noVNC), the
# same proven base the Firefox image uses — we just install Zen and point the
# app launcher at it. Railway-native: one HTTP port, no WebRTC/UDP.
FROM jlesage/baseimage-gui:debian-12-v4

# Runtime libraries a Gecko browser (Zen = Firefox-based) needs, + fetch tools.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        xz-utils curl ca-certificates \
        libgtk-3-0 libdbus-glib-1-2 libx11-xcb1 libxt6 libxtst6 \
        libasound2 libpci3 libegl1 libgl1 libgbm1 libgdk-pixbuf-2.0-0 \
        fonts-liberation fonts-noto-color-emoji fonts-noto-cjk && \
    rm -rf /var/lib/apt/lists/*

# Install Zen from the official Linux x86_64 tarball (auto-latest on rebuild).
RUN curl -fSL -o /tmp/zen.tar.xz \
      "https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz" && \
    tar -xJf /tmp/zen.tar.xz -C /opt && \
    rm /tmp/zen.tar.xz && \
    test -x /opt/zen/zen

# The GUI baseimage runs /startapp.sh as the windowed app.
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

ENV APP_NAME="Zen Browser"
ENV KEEP_APP_RUNNING=1
ENV DARK_MODE=1
# noVNC web UI is served on 5800 by the baseimage.
EXPOSE 5800
