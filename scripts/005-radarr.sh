#!/bin/bash

apt-get -y --allow-unauthenticated install mono-devel mediainfo sqlite3
curl -L -o radarr.tar.gz https://github.com/Radarr/Radarr/releases/download/v0.2.0.375/Radarr.develop.0.2.0.375.linux.tar.gz
tar xzvf radarr.tar.gz -C /opt/


tee '/lib/systemd/system/radarr.service' > /dev/null <<EOF
[Unit]
Description=Radarr Daemon
After=syslog.target network.target

[Service]
User=root
Group=root

Type=simple
ExecStart=/usr/bin/mono /opt/Radarr/Radarr.exe -nobrowser
TimeoutStopSec=20
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable radarr.service
systemctl start radarr.service