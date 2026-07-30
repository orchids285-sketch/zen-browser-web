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
      ca-certificates curl gnupg jq \
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

# Hide the noVNC viewer control bar (the "languette" that expands into Clipboard/
# Settings/Scaling/Quality/…). The embedded browser is driven directly via the
# canvas; the viewer chrome isn't wanted. Append the rule to noVNC's base.css.
RUN css="/opt/noVNC/app/styles/base.css"; \
    if [ -f "$css" ]; then \
      printf '\n/* FoundReach: hide noVNC control bar */\n#noVNC_control_bar_anchor,#noVNC_control_bar,#noVNC_control_bar_handle,#noVNC_status_bar,#noVNC_status{display:none!important;visibility:hidden!important;}\n' >> "$css"; \
      echo "NOVNC_BAR_HIDDEN"; \
    else echo "WARN: base.css not found at $css"; ls -la /opt/noVNC/app/styles/ 2>/dev/null || true; fi

# Dia-like UI CSS mods (VivalArc Arc layout + FoundReach warm/pink palette + font).
COPY mods/ /opt/mods/

# ROBUST skin load: inject the Dia CSS straight into Vivaldi's UI (browser.html)
# so it applies on EVERY boot — no fragile css_ui_mods pref/picker (which kept
# resetting across deploys). This is the classic file-level Vivaldi UI mod.
RUN UIHTML="$(find /opt/vivaldi/resources -name window.html -o -name browser.html 2>/dev/null | head -1)"; \
    if [ -n "$UIHTML" ]; then \
      UIDIR="$(dirname "$UIHTML")"; mkdir -p "$UIDIR/fr-mods" && cp /opt/mods/*.css "$UIDIR/fr-mods/"; \
      LINKS='<link rel="stylesheet" href="fr-mods/0-gtwalsheim.css"/><link rel="stylesheet" href="fr-mods/vivalarc.css"/><link rel="stylesheet" href="fr-mods/zz-dia.css"/>'; \
      if grep -qi '</head>' "$UIHTML"; then sed -i "s#</head>#${LINKS}</head>#I" "$UIHTML"; \
      elif grep -qi '</body>' "$UIHTML"; then sed -i "s#</body>#${LINKS}</body>#I" "$UIHTML"; \
      else printf '%s' "$LINKS" >> "$UIHTML"; fi; \
      echo "FR_UI_INJECTED into $UIHTML (refs=$(grep -c fr-mods "$UIHTML"))"; \
    else echo "FR_UI: UI html NOT FOUND"; find /opt/vivaldi -name '*.html' 2>/dev/null | head; fi

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

# noVNC window / page title (neutral — not a rebrand of Vivaldi itself).
ENV APP_NAME="Browser"
# If Vivaldi ever exits/crashes, restart it instead of shutting the container
# down (jlesage default kills the container when the app exits → crash-loop).
ENV KEEP_APP_RUNNING=1
EXPOSE 5800
