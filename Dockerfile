# Sử dụng Alpine làm base image
FROM alpine:latest

# Tạo thư mục làm việc
WORKDIR /NeganConsole

# Cài đặt các gói hệ thống cơ bản cần thiết từ mirror Trung Quốc cho apk (bỏ qua apk update như yêu cầu)
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk add --no-cache \
    bash procps coreutils bc ncurses iproute2 sysstat \
    util-linux pciutils curl jq nodejs npm py3-pip python3-dev libffi-dev build-base && \
    rm -rf /var/cache/apk/*

# Cài đặt các package Node.js từ registry mặc định của npm
RUN npm install --omit=dev colors randomstring user-agents hpack axios https commander socks node-telegram-bot-api --silent && \
    rm -rf /root/.npm

# Cài đặt các package Python từ registry mặc định của pip
RUN pip3 install --no-cache-dir --break-system-packages requests python-telegram-bot pytz

# Cấu hình ulimit và sysctl
# Tăng giới hạn tài nguyên (ulimit) và mở băng thông tối đa
RUN echo "* soft nofile 1000000" > /etc/security/limits.conf && \
    echo "* hard nofile 1000000" >> /etc/security/limits.conf && \
    echo "* soft nproc 65535" >> /etc/security/limits.conf && \
    echo "* hard nproc 65535" >> /etc/security/limits.conf && \
    echo "fs.file-max = 1000000" > /etc/sysctl.conf && \
    sysctl -p || true

# Cấu hình lại băng thông và các cài đặt mạng (chỉnh `sysctl` nếu cần)
RUN echo "net.core.somaxconn=1024" >> /etc/sysctl.conf && \
    echo "net.ipv4.tcp_max_syn_backlog=2048" >> /etc/sysctl.conf && \
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf && \
    sysctl -p || true

# Vô hiệu hóa firewall để tránh bị chặn
RUN iptables -F && \
    iptables -X && \
    iptables -P INPUT ACCEPT && \
    iptables -P FORWARD ACCEPT && \
    iptables -P OUTPUT ACCEPT

# Sao chép toàn bộ mã nguồn vào container
COPY . .

# Cấp quyền thực thi cho các file
RUN chmod +x ./*

# Chạy script start.sh
RUN /NeganConsole/start.sh
