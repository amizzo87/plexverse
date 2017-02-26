#!/bin/bash

add-apt-repository -y ppa:jcfp/ppa && apt-get update
apt-get install -y sabnzbdplus p7zip-full unrar unzip

mkdir -p /home/downloads/sabnzbd/complete
mkdir -p /home/downloads/sabnzbd/incomplete

sed -i "s/^USER=.*/USER=root/g" /etc/default/sabnzbdplus
sed -i "s/^HOST=.*/HOST=0.0.0.0/g" /etc/default/sabnzbdplus
sed -i "s/^PORT=.*/PORT=8080/g" /etc/default/sabnzbdplus

service sabnzbdplus restart