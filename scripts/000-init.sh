#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Execute 'sudo su' to swap to the root user." 
   exit 1
fi

sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication no/g" /etc/ssh/sshd_config

apt-get update && apt-get -y upgrade

apt-get install -y software-properties-common
add-apt-repository -y ppa:nikratio/s3ql && apt-get update
apt-get install -y build-essential
apt-get install -y s3ql


echo 'Initial config completed. Moving on...'