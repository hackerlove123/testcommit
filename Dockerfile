# Sử dụng Alpine làm base image
FROM alpine:latest

# Cài đặt các công cụ cần thiết để kiểm tra tài nguyên hệ thống
RUN apk update && \
    apk add --no-cache \
    bash procps coreutils ncurses iproute2 sysstat curl net-tools

# Tạo thư mục làm việc
WORKDIR /usr/local/bin

# Script để kiểm tra tài nguyên
RUN echo "#!/bin/bash \n\
# Kiểm tra CPU Usage \n\
echo 'CPU Usage:' \n\
top -bn1 | grep 'Cpu(s)' \n\
\n\
# Kiểm tra Memory Usage \n\
echo 'Memory Usage:' \n\
free -h \n\
\n\
# Kiểm tra Disk I/O \n\
echo 'Disk I/O Usage:' \n\
iostat -xz \n\
\n\
# Kiểm tra Network Traffic \n\
echo 'Network Traffic:' \n\
netstat -i \n\
\n\
# Kiểm tra giới hạn file descriptor và tiến trình \n\
echo 'File descriptor limit:' \n\
ulimit -n \n\
echo 'Process limit:' \n\
ulimit -u \n\
" > check_resources.sh

# Cấp quyền thực thi cho script
RUN chmod +x check_resources.sh

# Chạy script để kiểm tra tài nguyên khi container khởi động
CMD ["./check_resources.sh"]
