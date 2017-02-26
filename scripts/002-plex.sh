#!/bin/bash

curl -L -o plex.deb "https://plex.tv/downloads/latest/1?channel=16&build=linux-ubuntu-x86_64&distro=ubuntu"
dpkg -i plex.deb
rm plex.deb
mkdir -p "/cloud1/TV Shows"
mkdir -p "/cloud1/Movies"