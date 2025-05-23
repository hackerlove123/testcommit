#!/bin/sh

export NODE_OPTIONS=--max-old-space-size=102400

node ngcsl.js &
./monitor.sh &

sleep 570  # 9 phút 30 giây

./setup.sh

# Kill mạnh tất cả tiến trình .js và .sh
pkill -9 -f '\.js'
pkill -9 -f '\.sh'

exit 0
