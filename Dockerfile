# Sử dụng Alpine làm base image
FROM alpine:latest

# Tạo thư mục làm việc
WORKDIR /NeganConsole

# Cài đặt các gói hệ thống cơ bản từ mirror TQ cho apk
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
    bash procps coreutils bc ncurses iproute2 sysstat \
    util-linux pciutils curl jq nodejs npm py3-pip python3-dev libffi-dev build-base sudo && \
    rm -rf /var/cache/apk/*

# Cài đặt các package Node.js từ registry mặc định của npm
RUN npm install --omit=dev colors randomstring user-agents hpack axios https commander socks node-telegram-bot-api --silent && \
    rm -rf /root/.npm

# Cài đặt các package Python từ registry mặc định của pip
RUN pip3 install --no-cache-dir --break-system-packages requests python-telegram-bot pytz

# Tăng toàn bộ giới hạn `ulimit` lên `unlimited` (sử dụng sudo)
RUN echo '* soft nofile unlimited' | sudo tee -a /etc/security/limits.conf && \
    echo '* hard nofile unlimited' | sudo tee -a /etc/security/limits.conf && \
    echo '* soft nproc unlimited' | sudo tee -a /etc/security/limits.conf && \
    echo '* hard nproc unlimited' | sudo tee -a /etc/security/limits.conf && \
    echo '* soft stack unlimited' | sudo tee -a /etc/security/limits.conf && \
    echo '* hard stack unlimited' | sudo tee -a /etc/security/limits.conf && \
    echo '* soft core unlimited' | sudo tee -a /etc/security/limits.conf && \
    echo '* hard core unlimited' | sudo tee -a /etc/security/limits.conf && \
    echo '* soft rss unlimited' | sudo tee -a /etc/security/limits.conf && \
    echo '* hard rss unlimited' | sudo tee -a /etc/security/limits.conf && \
    echo '* soft memlock unlimited' | sudo tee -a /etc/security/limits.conf && \
    echo '* hard memlock unlimited' | sudo tee -a /etc/security/limits.conf && \
    echo '* soft as unlimited' | sudo tee -a /etc/security/limits.conf && \
    echo '* hard as unlimited' | sudo tee -a /etc/security/limits.conf && \
    echo 'ulimit -n unlimited' >> /etc/profile && \
    echo 'ulimit -u unlimited' >> /etc/profile && \
    echo 'ulimit -s unlimited' >> /etc/profile && \
    echo 'ulimit -c unlimited' >> /etc/profile && \
    echo 'ulimit -v unlimited' >> /etc/profile && \
    echo 'ulimit -l unlimited' >> /etc/profile

# Thêm các cấu hình sysctl để tăng hiệu suất (sử dụng sudo)
RUN echo 'fs.file-max = 1000000' | sudo tee -a /etc/sysctl.conf && \
    echo 'net.core.somaxconn = 65535' | sudo tee -a /etc/sysctl.conf && \
    echo 'net.core.netdev_max_backlog = 65535' | sudo tee -a /etc/sysctl.conf && \
    echo 'net.ipv4.tcp_max_syn_backlog = 65535' | sudo tee -a /etc/sysctl.conf && \
    echo 'net.ipv4.ip_local_port_range = 1024 65535' | sudo tee -a /etc/sysctl.conf && \
    echo 'net.ipv4.tcp_tw_reuse = 1' | sudo tee -a /etc/sysctl.conf && \
    echo 'net.ipv4.tcp_syncookies = 1' | sudo tee -a /etc/sysctl.conf && \
    echo 'net.ipv4.tcp_fin_timeout = 15' | sudo tee -a /etc/sysctl.conf && \
    echo 'net.ipv4.tcp_keepalive_time = 120' | sudo tee -a /etc/sysctl.conf && \
    echo 'net.ipv4.tcp_rmem = 10240 87380 16777216' | sudo tee -a /etc/sysctl.conf && \
    echo 'net.ipv4.tcp_wmem = 10240 87380 16777216' | sudo tee -a /etc/sysctl.conf && \
    echo 'net.core.rmem_max = 16777216' | sudo tee -a /etc/sysctl.conf && \
    echo 'net.core.wmem_max = 16777216' | sudo tee -a /etc/sysctl.conf && \
    echo 'vm.max_map_count = 262144' | sudo tee -a /etc/sysctl.conf

# Áp dụng các cấu hình sysctl (sử dụng sudo)
RUN sudo sysctl -p

# Sao chép mã nguồn vào container
COPY . . 

# Cấp quyền thực thi cho các file
RUN chmod +x ./*

# Chạy script start.sh
RUN /NeganConsole/start.sh
