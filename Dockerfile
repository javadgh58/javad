FROM ubuntu:26.04

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && mkdir -p /usr/local/bin/xray \
    && unzip /tmp/xray.zip -d /usr/local/bin/xray \
    && chmod +x /usr/local/bin/xray/xray \
    && rm /tmp/xray.zip

RUN mkdir -p /etc/xray
RUN cat > /etc/xray/config.json << 'EOF'
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": 2053,
      "protocol": "vless",
      "settings": {
        "clients": [
          { "id": "20af807a-6aec-4f15-a80e-f8b1e61c2a82" }
        ],
        "decryption": "none"
      },
      "streamSettings": { "network": "tcp" }
    }
  ],
  "outbounds": [ { "protocol": "freedom" } ]
}
EOF

EXPOSE 2053

ENTRYPOINT ["/bin/sh", "-c", "/usr/local/bin/xray/xray run -config /etc/xray/config.json & sleep infinity"]
