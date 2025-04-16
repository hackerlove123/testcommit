# Use an official base image
FROM ubuntu:20.04

# Set the working directory inside the container
WORKDIR /app

# Install necessary utilities
RUN apt-get update && apt-get install -y \
    procps \
    iostat \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Set the entry point to run the shell script or commands
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
    ulimit -a;
"
