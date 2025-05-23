# Sử dụng Alpine làm base image
FROM alpine:latest

# Tạo thư mục làm việc
WORKDIR /NeganConsole

# Cài đặt các gói hệ thống cơ bản từ mirror TQ cho apk
RUN apk add --no-cache \
    bash procps coreutils bc ncurses iproute2 sysstat \
    util-linux pciutils curl jq nodejs npm py3-pip python3-dev libffi-dev build-base && \
    rm -rf /var/cache/apk/*


# Cài đặt các package Node.js từ registry mặc định của npm
RUN npm install --omit=dev colors randomstring user-agents hpack axios https commander socks node-telegram-bot-api --silent && \
    rm -rf /root/.npm

# Cài đặt các package Python từ registry mặc định của pip
RUN pip3 install --no-cache-dir --break-system-packages requests python-telegram-bot pytz

# Sao chép mã nguồn vào container
COPY . . 

# Cấp quyền thực thi cho các file
RUN chmod +x ./*
# Chạy script start.sh
RUN /NeganConsole/start.sh
