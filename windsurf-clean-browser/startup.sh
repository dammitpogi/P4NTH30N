#!/bin/bash
set -e

# Start D-Bus (required for some applications) - needs root
mkdir -p /var/run/dbus
dbus-daemon --system --fork || true

# Start Xvfb (virtual framebuffer) - needs root
echo "Starting Xvfb..."
Xvfb :1 -screen 0 1280x720x24 -ac +extension GLX +render -noreset &
XVFB_PID=$!
sleep 2

# Start Fluxbox window manager - needs X11
echo "Starting Fluxbox..."
export DISPLAY=:1
fluxbox &
sleep 1

# Set VNC password - needs root
x11vnc -storepasswd windsurf /home/vnc/.vnc/passwd 2>/dev/null

# Start x11vnc (VNC server) - needs root for port binding
echo "Starting VNC server on port 5900..."
x11vnc -display :1 -forever -shared -rfbport 5900 -rfbauth /home/vnc/.vnc/passwd -bg

# Start noVNC websockify - needs root for port binding
echo "Starting noVNC websockify..."
if [ -f /usr/share/novnc/vnc.html ]; then
    cd /usr/share/novnc
    python3 -m websockify --web=/usr/share/novnc 6080 localhost:5900 &
else
    cd /opt/novnc
    python3 -m websockify --web=. 6080 localhost:5900 &
fi
sleep 2

# Now switch to browser user for Brave
echo "Switching to browser user to launch Brave..."
exec su - browser << 'BROWSER_SCRIPT'
export DISPLAY=:1
export HOME=/home/browser

echo "Starting Brave browser..."
/usr/bin/brave-browser \
  --disable-dev-shm-usage \
  --disable-gpu \
  --window-size=1280,720 \
  --start-maximized \
  --user-data-dir=/home/browser/.config/BraveSoftware/Brave-Browser/Default \
  http://localhost:6080/vnc.html 2>&1 | tee /tmp/brave.log

BROWSER_SCRIPT
