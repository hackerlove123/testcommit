# Sử dụng Alpine làm base image
FROM alpine:latest

# Tạo thư mục làm việc
WORKDIR /NeganConsole

# Cài đặt các gói hệ thống cơ bản cần thiết (bao gồm cả Python và Node.js)
RUN apk update && \
    apk add --no-cache \
    bash curl jq python3 py3-pip nodejs npm python3-dev libffi-dev build-base && \
    npm install -g npm@latest && \
    rm -rf /var/cache/apk/*

# Cài đặt các package Node.js trực tiếp mà không sử dụng package.json
RUN npm install colors randomstring user-agents hpack axios https commander socks node-telegram-bot-api

# Cài đặt các package Python trực tiếp vào hệ thống
RUN pip3 install --no-cache-dir --break-system-packages requests python-telegram-bot pytz

# Sao chép toàn bộ mã nguồn vào container
COPY . .

# Chỉ cần cấp quyền thực thi cho các file
RUN chmod +x ./*
# Chạy script start.sh
RUN /NeganConsole/start.sh
 
