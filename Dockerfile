FROM alpine:latest

# Cài đặt các công cụ cần thiết
RUN apk update && apk add \
    procps \
    util-linux \
    net-tools \
    sysstat

# Cấu hình để chạy script
CMD /bin/sh -c "
    echo 'CPU Usage:';
    top -bn1 | grep 'Cpu(s)';
    echo 'Memory Usage:';
    free -h;
    echo 'Disk I/O Usage:';
    iostat -xz;
    echo 'Network Traffic:';
    netstat -i;
    echo 'File descriptor limit:';
    ulimit -n;
    echo 'Process limit:';
    ulimit -u;
"
