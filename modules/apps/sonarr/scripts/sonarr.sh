#!/bin/bash

until [[ $(which aptdcon) ]]; do echo 'Waiting for aptdcon installation...'; sleep 5; done

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0xA236C58F409091A18ACA53CBEBFF6B99D9B78493
aptdcon --add-repository "deb http://apt.sonarr.tv/ master main"

aptdcon --refresh

yes | aptdcon --hide-terminal --install "nzbdrone"

tee '/etc/systemd/system/sonarr.service' > /dev/null <<EOF
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

sleep 10

sed -i -e '/<Config>/,/<\/Config>/ s|<UrlBase></UrlBase>|<UrlBase>/sonarr</UrlBase>|g' /root/.config/NzbDrone/config.xml

systemctl restart sonarr.service