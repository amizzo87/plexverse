#!/bin/bash

curl -L -o /opt/goofys "https://github.com/kahing/goofys/releases/latest/download/goofys"
chmod a+x /opt/goofys

mkdir ~/.aws
cat <<EOF > ~/.aws/credentials
[default]
aws_access_key_id = $1
aws_secret_access_key = $2
EOF

crontab -l > current_cron
echo "@reboot /opt/goofys -o allow_other --endpoint $3 $4 /plexmedia" >> current_cron
crontab current_cron
rm current_cron

/opt/goofys -o allow_other --endpoint $3 $4 /plexmedia