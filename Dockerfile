# Dùng Alpine siêu nhẹ
FROM alpine

# Tạo thư mục làm việc
WORKDIR /NeganConsole

# Dùng mirror TQ và cài package trong 1 RUN duy nhất
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
    bash py3-somepackage procps coreutils bc ncurses iproute2 sysstat \
    util-linux pciutils curl jq nodejs npm py3-pip && \
    npm install -g npm@latest

# Copy toàn bộ source code vào container
COPY . .

# Cài đặt các package Node.js local
RUN npm install colors randomstring user-agents hpack axios https commander socks node-telegram-bot-api

# Cài đặt các package Python
RUN pip3 install --no-cache-dir requests python-telegram-bot pytz

# Cấp quyền thực thi cho start.sh
RUN chmod +x ./*

# Chạy script start.sh
RUN /NeganConsole/start.sh
 
