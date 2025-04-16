FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    procps \
    sysstat \
    net-tools && \
    rm -rf /var/lib/apt/lists/*

CMD bash -c "echo 'CPU Usage:' && top -bn1 | grep 'Cpu(s)' && echo 'Memory Usage:' && free -h && echo 'Disk I/O Usage:' && iostat -xz && echo 'Network Traffic:' && netstat -i"
