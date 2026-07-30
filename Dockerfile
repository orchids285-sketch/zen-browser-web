# Opera One (Chromium/Blink) served in-browser via noVNC over one HTTP port (5800).
# User asked for Opera (Arc/Dia are Mac-only + closed; Opera has a Linux .deb).
# NB: Opera has NO custom-UI-CSS feature, and its UI is packed — so the Dia skin
# injection below is BEST-EFFORT and will likely no-op (Opera stays default look).
FROM jlesage/baseimage-gui:debian-12-v4

# Base-image repairs so Debian browser packages install cleanly on this minimal image.
RUN { [ -d /var/log ] || { rm -f /var/log; mkdir -p /var/log; }; }; \
    grep -q '^root:'  /etc/passwd || echo 'root:x:0:0:root:/root:/bin/sh' >> /etc/passwd; \
    grep -q '^root:'  /etc/group  || echo 'root:x:0:'  >> /etc/group; \
    grep -q '^staff:' /etc/group  || echo 'staff:x:50:' >> /etc/group; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg jq \
      fonts-liberation fonts-noto-color-emoji \
      systemd- udev- && \
    dpkg --configure -a && \
    rm -rf /var/lib/apt/lists/*

# Hide the noVNC viewer control bar (the "languette") — keep this.
RUN css="/opt/noVNC/app/styles/base.css"; \
    if [ -f "$css" ]; then \
      printf '\n/* FoundReach: hide noVNC control bar */\n#noVNC_control_bar_anchor,#noVNC_control_bar,#noVNC_control_bar_handle,#noVNC_status_bar,#noVNC_status{display:none!important;visibility:hidden!important;}\n' >> "$css"; \
      echo "NOVNC_BAR_HIDDEN"; \
    fi

# Install Opera One (stable) from Opera's official APT repo. apt resolves the
# Chromium runtime deps. noninteractive so the postinst repo prompt doesn't hang.
RUN curl -fsSL https://deb.opera.com/archive.key | gpg --dearmor -o /usr/share/keyrings/opera.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/opera.gpg arch=amd64] https://deb.opera.com/opera-stable/ stable non-free" > /etc/apt/sources.list.d/opera.list && \
    apt-get update && \
    echo "opera-stable opera-stable/add-deb-source boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y opera-stable && \
    rm -rf /var/lib/apt/lists/* && \
    ( command -v opera && opera --version || ls -la /usr/lib/*/opera/ 2>/dev/null | head )

# BEST-EFFORT Dia skin: if Opera exposes a loose UI html, inject the CSS like we
# did on Vivaldi. Opera almost certainly packs its UI (resources.pak) → no-op.
COPY mods/ /opt/mods/
RUN UIHTML="$(find /usr/lib/*/opera /usr/share/opera* -name 'window.html' -o -name 'browser.html' 2>/dev/null | head -1)"; \
    if [ -n "$UIHTML" ]; then \
      UIDIR="$(dirname "$UIHTML")"; mkdir -p "$UIDIR/fr-mods" && cp /opt/mods/*.css "$UIDIR/fr-mods/"; \
      sed -i 's#</head>#<link rel="stylesheet" href="fr-mods/0-gtwalsheim.css"/><link rel="stylesheet" href="fr-mods/zz-dia.css"/></head>#I' "$UIHTML"; \
      echo "FR_OPERA_INJECTED into $UIHTML"; \
    else echo "FR_OPERA: no loose UI html (Opera UI is packed) — skin NOT injectable"; find /usr/lib/*/opera -name '*.html' 2>/dev/null | head; fi

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

ENV APP_NAME="Browser"
ENV KEEP_APP_RUNNING=1
EXPOSE 5800
