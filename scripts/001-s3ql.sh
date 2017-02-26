#!/bin/bash

echo "Please wait..."
sleep 10

while [ ! -f screenlog.0 ]
do
  echo "Waiting for screen..."
  sleep 5
done

while [[ "$(head -n1 screenlog.0)" != S* ]]
do
  echo "Waiting for s3ql_oauth_client..."
  sleep 5
done
    
tail screenlog.0
echo "Follow instructions above and enter the code to authorize with Google."

while [[ "$(tail -n 1 screenlog.0 | sed 's/ //g')" != 1* ]]
do
  echo "Waiting..."
  sleep 5
  if [[ "$(tail -n 1 screenlog.0 | sed 's/ //g')" == 1* ]] ; then
         echo "Token found!"
         break;
  fi
done

tail -n 1 screenlog.0 | sed 's/ //g' >> /root/.s3ql/authinfo2
killall screen
rm screenlog.0
echo "The s3ql authfile has been created."

mkdir -p /cloud1
mkdir -p /var/cache/s3ql
echo "The s3ql config has completed successfully. Onto the next!"