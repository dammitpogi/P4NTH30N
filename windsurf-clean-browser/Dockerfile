# Windsurf Clean Browser - Docker Container
# Ubuntu 22.04 + Brave + TigerVNC + noVNC
# Fingerprint evasion for manual Windsurf registration

FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables to reduce fingerprinting
ENV DISPLAY=:1
ENV QT_QPA_PLATFORM=offscreen
ENV XDG_RUNTIME_DIR=/tmp/runtime
ENV TMPDIR=/tmp

# Create necessary directories and non-root user
RUN mkdir -p /tmp/runtime /tmp/vnc /home/vnc /opt/brave /opt/novnc /var/run/dbus && \
    useradd -m -s /bin/bash browser && \
    mkdir -p /home/browser/.config && \
    chown -R browser:browser /home/browser

# Install dependencies - Brave dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    gnupg2 \
    ca-certificates \
    apt-transport-https \
    unzip \
    xz-utils \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgtk-3-0 \
    fonts-liberation \
    libappindicator3-1 \
    x11vnc \
    xvfb \
    fluxbox \
    dbus-x11 \
    x11-utils \
    x11-xserver-utils \
    wmctrl \
    xdotool \
    xterm \
    feh \
    libvulkan1 \
    xdg-utils \
    libu2f-udev \
    libxshmfence1 \
    python3 \
    python3-websockify \
    && rm -rf /var/lib/apt/lists/*

# Install Brave Browser
RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list && \
    apt-get update && apt-get install -y brave-browser && \
    rm -rf /var/lib/apt/lists/*

# Install noVNC from package manager
RUN apt-get update && apt-get install -y --no-install-recommends novnc \
    && rm -rf /var/lib/apt/lists/*

# Create VNC password file
RUN mkdir -p /home/vnc/.vnc && \
    x11vnc -storepasswd windsurf /home/vnc/.vnc/passwd

# Copy VNC startup configuration
COPY config/vnc-xstartup /home/vnc/.vnc/xstartup
RUN chmod +x /home/vnc/.vnc/xstartup

# Set ownership
RUN chown -R root:root /home/vnc

# Expose ports
EXPOSE 5900 6080

# Copy startup script (already has correct LF line endings)
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Run startup script
CMD ["/startup.sh"]
