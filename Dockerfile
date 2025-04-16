FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    neofetch \
    procps \
    net-tools \
    iputils-ping \
    curl \
    wget \
    iftop \
    iotop \
    sysstat \
    lsof \
    dnsutils \
    && apt-get clean

CMD bash -c "\
    echo '==== SYSTEM INFO (neofetch) ====' && neofetch && \
    echo '==== UPTIME & LOAD ====' && uptime && \
    echo '==== CPU & RAM USAGE ====' && top -bn1 | head -20 && \
    echo '==== MEMORY (free -h) ====' && free -h && \
    echo '==== DISK USAGE (df -h) ====' && df -h && \
    echo '==== NETWORK INTERFACES (ifconfig) ====' && ifconfig && \
    echo '==== OPEN PORTS (netstat) ====' && netstat -tulnp && \
    echo '==== ACTIVE CONNECTIONS ====' && netstat -ant && \
    echo '==== DNS TEST (ping google.com) ====' && ping -c 2 google.com || true && \
    echo '==== WHO IS USING BANDWIDTH (iftop -n snapshot) ====' && echo '--- iftop cần chạy tương tác, bỏ qua ---' && \
    echo '==== IO STAT ====' && iostat && \
    echo '==== DONE ====' \
"
