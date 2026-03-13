FROM lscr.io/linuxserver/webtop:ubuntu-kde

# Labels
LABEL maintainer="trumblejoe"
LABEL org.opencontainers.image.title="Fade-In"
LABEL org.opencontainers.image.description="Fade-In Professional screenwriting software running in a browser-accessible KDE desktop"
LABEL org.opencontainers.image.url="https://github.com/trumblejoe/docker-fadein"
LABEL org.opencontainers.image.source="https://github.com/trumblejoe/docker-fadein"

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    libgtk-3-0 \
    libnotify4 \
    libnss3 \
    libxss1 \
    libxtst6 \
    xdg-utils \
    libatspi2.0-0 \
    libdrm2 \
    libgbm1 \
    libxcb-dri3-0 \
    && rm -rf /var/lib/apt/lists/*

# Download and install Fade-In
ARG FADEIN_VERSION=4.5.0.7026
RUN wget -q "https://www.fadeinpro.com/dl/linux/fadein_${FADEIN_VERSION}_amd64.deb" -O /tmp/fadein.deb \
    && dpkg -i /tmp/fadein.deb || apt-get install -yf \
    && rm /tmp/fadein.deb

# Create default autostart entry so Fade-In launches with the desktop
RUN mkdir -p /defaults/autostart && \
    echo "[Desktop Entry]\nType=Application\nName=Fade-In\nExec=fadein\nX-GNOME-Autostart-enabled=true" \
    > /defaults/autostart/fadein.desktop

# Expose the WebUI port (KasMVNC via webtop)
EXPOSE 3001

# Volumes
VOLUME ["/config"]
