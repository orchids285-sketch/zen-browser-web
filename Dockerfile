# Zen Browser, served in the browser via noVNC over a single HTTP port (5800).
# We base on jlesage/firefox — it already ships the full Gecko/GTK/X runtime and
# the noVNC GUI stack (proven working on Railway) — and just drop Zen in over it,
# repointing the app launcher. Minimal apt (only xz to extract) so nothing drags
# in systemd. Railway-native: one HTTP port, no WebRTC/UDP.
FROM jlesage/firefox:latest

USER root

# Only what's needed to fetch + extract the Zen tarball (Gecko libs already present).
RUN apt-get update && \
    apt-get install -y --no-install-recommends xz-utils curl ca-certificates && \
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
