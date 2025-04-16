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
    && apt-get clean && \
    echo "==== SYSTEM INFO ====" && \
    neofetch && \
    uptime && \
    top -bn1 | head -20 && \
    free -h && \
    df -h && \
    ifconfig && \
    netstat -tulnp || true && \
    echo "==== END ===="
