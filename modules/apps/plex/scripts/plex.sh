#!/bin/bash

until [[ $(which aptdcon) ]]; do echo 'Waiting for aptdcon installation...'; sleep 5; done

mkdir -p /plexmedia/Movies
mkdir -p '/plexmedia/TV Shows'

curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
aptdcon --add-repository "deb https://downloads.plex.tv/repo/deb public main"

aptdcon --refresh

yes | aptdcon --hide-terminal --install plexmediaserver