#!/bin/bash

until [[ $(which aptdcon) ]]; do echo 'Waiting for aptdcon installation...'; sleep 5; done

yes | aptdcon --hide-terminal --install "nginx"

cat <<EOF > /etc/nginx/sites-available/default
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html;

	add_header  X-Robots-Tag "noindex, nofollow, nosnippet, noarchive";

	location /radarr/ {
		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
		proxy_pass http://127.0.0.1:7878/radarr/;
	}

	location /sonarr/ {
		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
		proxy_pass http://127.0.0.1:8989/sonarr/;
	}

	location /sabnzbd/ {
		proxy_set_header X-Forwarded_for \$proxy_add_x_forwarded_for;
		proxy_pass http://127.0.0.1:8080/sabnzbd/;
	}
}
EOF

systemctl restart nginx