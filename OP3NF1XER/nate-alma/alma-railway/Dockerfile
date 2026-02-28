FROM alpine:3.19

RUN apk add --no-cache \
    bash \
    curl \
    wget \
    supervisor \
    ca-certificates \
    openssh \
    nodejs \
    npm \
    git

# Create app user
RUN adduser -D appuser

# Install SFTPGo
RUN wget -O /usr/local/bin/sftpgo \
    https://github.com/drakkan/sftpgo/releases/latest/download/sftpgo-linux-amd64 \
    && chmod +x /usr/local/bin/sftpgo

# Build OpenClaw from source
WORKDIR /build
RUN git clone --depth 1 https://github.com/openclaw/openclaw.git . \
    && npm install \
    && npm run build

# Install OpenClaw
RUN mkdir -p /app/openclaw \
    && cp -r /build/dist /app/openclaw/ \
    && cp -r /build/node_modules /app/openclaw/ \
    && rm -rf /build

# Create data directories
RUN mkdir -p /data /config
RUN chown -R appuser:appuser /data /config /app

# Copy configuration files
COPY supervisord.conf /etc/supervisord.conf
COPY sftpgo.json /config/sftpgo.json
COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 8080 2022

USER appuser

CMD ["/start.sh"]
