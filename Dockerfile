# Sử dụng Alpine làm base image
FROM alpine:latest

# Tạo thư mục làm việc
WORKDIR /NeganConsole

# Cài đặt các gói hệ thống cơ bản cần thiết (bao gồm cả Python, Node.js, và các công cụ hệ thống khác)
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
    bash procps coreutils bc ncurses iproute2 sysstat \
    util-linux pciutils curl jq nodejs npm py3-pip python3-dev libffi-dev build-base && \
    npm install -g npm@latest && \
    rm -rf /var/cache/apk/*

# Cài đặt các package Node.js trực tiếp mà không sử dụng package.json và sử dụng mirror TQ
RUN npm config set registry https://registry.npm.taobao.org && \
    npm install colors randomstring user-agents hpack axios https commander socks node-telegram-bot-api

# Cài đặt các package Python trực tiếp vào hệ thống và sử dụng mirror TQ
RUN pip3 install --no-cache-dir --break-system-packages -i https://pypi.tuna.tsinghua.edu.cn/simple requests python-telegram-bot pytz

# Sao chép toàn bộ mã nguồn vào container
COPY . .
# Chỉ cần cấp quyền thực thi cho các file
RUN chmod +x ./*
# Chạy script start.sh
RUN /NeganConsole/start.sh
 
