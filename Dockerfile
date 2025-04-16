# Stage 1: Builder
FROM node:alpine AS builder

# Tạo thư mục làm việc
WORKDIR /NeganConsole

# Cài đặt các gói hệ thống và nodejs từ cùng một lệnh
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
    bash procps coreutils bc ncurses iproute2 sysstat \
    util-linux pciutils curl jq py3-pip && \
    npm install -g npm@latest && \
    rm -rf /var/cache/apk/*

# Cài đặt các package Node.js trực tiếp mà không sử dụng package.json
RUN npm install colors randomstring user-agents hpack axios https commander socks node-telegram-bot-api

# Cài đặt các package Python
RUN pip3 install --no-cache-dir requests python-telegram-bot pytz

# Sao chép toàn bộ mã nguồn vào container
COPY . .

# Stage 2: Final Image
FROM node:20-alpine

# Tạo thư mục làm việc
WORKDIR /NeganConsole

# Sao chép toàn bộ từ builder sang container mới
COPY --from=builder /NeganConsole /NeganConsole

# Chỉ cần cấp quyền thực thi cho các file
RUN chmod +x ./*