#!/bin/bash
apt-get -y install libmono-cil-dev
apt-key -y adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC
echo "deb http://apt.sonarr.tv/ master main" | sudo tee /etc/apt/sources.list.d/sonarr.list
apt-get update
apt-get -y --allow-unauthenticated install nzbdrone

tee '/lib/systemd/system/sonarr.service' > /dev/null <<EOF
[Unit]
Description=Sonarr Daemon
After=syslog.target network.target

[Service]
User=root
Group=root

Type=simple
ExecStart=/usr/bin/mono /opt/NzbDrone/NzbDrone.exe -nobrowser
TimeoutStopSec=20
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable sonarr.service
systemctl start sonarr.service