# Google Chrome (Chromium/Blink) served in-browser via noVNC over one HTTP port
# (5800). User asked for Chrome: it's Chromium, has a Linux .deb, and is CLEAN
# (no Opera-style ads). NB: like Opera, Chrome's UI is PACKED (resources.pak) →
# NO custom-CSS skin possible; it stays the standard clean Chrome look.
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

# Install Google Chrome stable from Google's official APT repo. apt resolves deps.
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/google-chrome.gpg arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/* && \
    ( command -v google-chrome-stable && google-chrome-stable --version )

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

ENV APP_NAME="Browser"
ENV KEEP_APP_RUNNING=1
EXPOSE 5800
