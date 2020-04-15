#!/bin/bash

until [[ $(which aptdcon) ]]; do echo 'Waiting for aptdcon installation...'; sleep 5; done

yes | aptdcon --hide-terminal --install "mono-devel" "mediainfo" "sqlite3"

cd /tmp && curl -L -O $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )
tar -xvzf Radarr.develop.*.linux.tar.gz
mv Radarr /opt/

tee '/etc/systemd/system/radarr.service' > /dev/null <<EOF
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

sleep 10

sed -i -e '/<Config>/,/<\/Config>/ s|<UrlBase></UrlBase>|<UrlBase>/radarr</UrlBase>|g' /root/.config/Radarr/config.xml

systemctl restart radarr.service