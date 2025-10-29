#!/usr/bin/env bash

# Nyan Cat Neofetch - Animated ASCII art with system info
# Based on the original Nyancat.sh

# Parse command line arguments
PLAY_AUDIO=false
for arg in "$@"; do
    case $arg in
        --unmute|-u)
            PLAY_AUDIO=true
            shift
            ;;
        --help|-h)
            echo "Usage: nyanfetch [OPTIONS]"
            echo "Animated Nyan Cat ASCII art with system information"
            echo ""
            echo "Options:"
            echo "  --unmute, -u    Play Nyan Cat music"
            echo "  --help, -h      Show this help message"
            exit 0
            ;;
    esac
done

# Get the script directory (resolve symlink)
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$SCRIPT_DIR/$SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"

# Check if running from installation or development
if [ -d "/usr/share/nyanfetch" ]; then
    DATA_DIR="/usr/share/nyanfetch"
elif [ -d "/usr/local/share/nyanfetch" ]; then
    DATA_DIR="/usr/local/share/nyanfetch"
else
    DATA_DIR="$SCRIPT_DIR"
fi

# Start audio playback if requested
if [ "$PLAY_AUDIO" = true ]; then
    AUDIO_FILE="${DATA_DIR}/nyancat.wav"
    if [ -f "$AUDIO_FILE" ]; then
        # Try different audio players in order of preference
        if command -v paplay &> /dev/null; then
            paplay --volume=65536 "$AUDIO_FILE" &> /dev/null &
        elif command -v aplay &> /dev/null; then
            aplay -q "$AUDIO_FILE" &> /dev/null &
        elif command -v ffplay &> /dev/null; then
            ffplay -nodisp -autoexit -loglevel quiet "$AUDIO_FILE" &> /dev/null &
        elif command -v mpg123 &> /dev/null; then
            mpg123 -q "$AUDIO_FILE" &> /dev/null &
        else
            echo "Warning: No audio player found. Install pulseaudio-utils, alsa-utils, or ffmpeg." >&2
        fi
        AUDIO_PID=$!
        # Kill audio on exit
        trap "kill $AUDIO_PID 2>/dev/null; tput cnorm; clear; exit 0" INT TERM
    else
        echo "Warning: Audio file not found at $AUDIO_FILE" >&2
    fi
else
    # Normal cleanup without audio
    trap 'tput cnorm; clear; exit 0' INT TERM
fi

# Colors for system info
RESET="\033[0m"
CYAN="\033[36m"
YELLOW="\033[33m"
WHITE="\033[97m"
GRAY="\033[90m"
BOLD="\033[1m"
RED="\033[31m"
ORANGE="\033[38;5;208m"
GREEN="\033[32m"
BLUE="\033[34m"
MAGENTA="\033[35m"
PINK="\033[38;5;213m"

# Get system info functions
get_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$NAME"
    else
        uname -s
    fi
}

get_kernel() {
    uname -r
}

get_uptime() {
    uptime -p | sed 's/up //'
}

get_shell() {
    basename "$SHELL"
}

get_packages() {
    if command -v dpkg &> /dev/null; then
        dpkg -l | grep -c '^ii'
    elif command -v rpm &> /dev/null; then
        rpm -qa | wc -l
    elif command -v pacman &> /dev/null; then
        pacman -Q | wc -l
    else
        echo "N/A"
    fi
}

get_cpu() {
    grep "model name" /proc/cpuinfo | head -1 | cut -d':' -f2 | sed 's/^[ \t]*//'
}

get_memory() {
    free -h | awk '/^Mem:/ {print $3 " / " $2}'
}

get_de() {
    echo "${XDG_CURRENT_DESKTOP:-$DESKTOP_SESSION}"
}

get_wm() {
    echo "${XDG_SESSION_TYPE:-N/A}"
}

get_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1
}

get_cpu_usage_int() {
    printf "%.0f" $(get_cpu_usage)
}

get_memory_percent() {
    free | awk '/^Mem:/ {printf "%.0f", ($3/$2)*100}'
}

get_disk() {
    df -h / | awk 'NR==2 {print $3 " / " $2}'
}

# Create a progress bar
make_bar() {
    local percent=$1
    local width=20
    local filled=$(( percent * width / 100 ))
    local empty=$(( width - filled ))
    
    local bar="${GREEN}"
    if [ $percent -gt 80 ]; then
        bar="${RED}"
    elif [ $percent -gt 60 ]; then
        bar="${YELLOW}"
    fi
    
    bar="${bar}["
    for ((i=0; i<filled; i++)); do
        bar="${bar}━"
    done
    bar="${bar}${GRAY}"
    for ((i=0; i<empty; i++)); do
        bar="${bar}━"
    done
    bar="${bar}${RESET}]"
    
    echo -e "$bar"
}

get_gpu() {
    if command -v lspci &> /dev/null; then
        lspci | grep -i vga | cut -d':' -f3 | sed 's/^[ \t]*//' | head -1 | cut -c1-40
    else
        echo "N/A"
    fi
}

get_resolution() {
    if command -v xrandr &> /dev/null; then
        xrandr | grep '*' | awk '{print $1}' | head -1
    else
        echo "N/A"
    fi
}

# Collect all system info once to prevent flickering
collect_sysinfo() {
    CPU_PERCENT=$(get_cpu_usage_int)
    MEM_PERCENT=$(get_memory_percent)
    MEM_USAGE=$(get_memory)
    CPU_BAR=$(make_bar $CPU_PERCENT)
    MEM_BAR=$(make_bar $MEM_PERCENT)
    
    SYSINFO_USER="${BOLD}${CYAN}$(whoami)${RESET}${WHITE}@${RESET}${BOLD}${CYAN}$(hostname)${RESET}"
    SYSINFO_LINE="${GRAY}────────────────────────────────────────────────────${RESET}"
    SYSINFO_OS="${BOLD}${YELLOW}OS${RESET}:         $(get_os)"
    SYSINFO_KERNEL="${BOLD}${YELLOW}Kernel${RESET}:     $(get_kernel)"
    SYSINFO_UPTIME="${BOLD}${YELLOW}Uptime${RESET}:     $(get_uptime)"
    SYSINFO_SHELL="${BOLD}${YELLOW}Shell${RESET}:      $(get_shell)"
    SYSINFO_PACKAGES="${BOLD}${YELLOW}Packages${RESET}:   $(get_packages)"
    SYSINFO_DE="${BOLD}${YELLOW}DE${RESET}:         $(get_de)"
    SYSINFO_WM="${BOLD}${YELLOW}WM${RESET}:         $(get_wm)"
    SYSINFO_CPU="${BOLD}${YELLOW}CPU${RESET}:        $(get_cpu)"
    SYSINFO_GPU="${BOLD}${YELLOW}GPU${RESET}:        $(get_gpu)"
    SYSINFO_DISK="${BOLD}${YELLOW}Disk${RESET}:       $(get_disk)"
    SYSINFO_RESOLUTION="${BOLD}${YELLOW}Resolution${RESET}: $(get_resolution)"
    SYSINFO_COLORS="${RED}███${RESET} ${ORANGE}███${RESET} ${YELLOW}███${RESET} ${GREEN}███${RESET} ${CYAN}███${RESET} ${BLUE}███${RESET} ${MAGENTA}███${RESET} ${PINK}███${RESET}"
}

# Update dynamic values (called every 15 seconds)
update_dynamic_info() {
    CPU_PERCENT=$(get_cpu_usage_int)
    MEM_PERCENT=$(get_memory_percent)
    MEM_USAGE=$(get_memory)
    CPU_BAR=$(make_bar $CPU_PERCENT)
    MEM_BAR=$(make_bar $MEM_PERCENT)
}

# Collect system info once (no flickering)
collect_sysinfo

# Clear screen once at the start
clear

# Hide cursor
tput civis

img_num=1
frame_count=0
update_interval=10

while true; do
    # Move cursor to top-left without clearing screen
    tput cup 0 0
    
    cat "${DATA_DIR}/nyancat-${img_num}.ans"
    
    # Update dynamic values every 15 seconds
    if [[ $((frame_count % update_interval)) -eq 0 ]]; then
        update_dynamic_info
    fi
    
    # Display pre-collected system info on the right side (no flickering)
    tput cup 3 130
    echo -ne "$SYSINFO_USER"
    tput cup 4 130
    echo -ne "$SYSINFO_LINE"
    tput cup 5 130
    echo -ne "$SYSINFO_OS"
    tput cup 6 130
    echo -ne "$SYSINFO_KERNEL"
    tput cup 7 130
    echo -ne "$SYSINFO_UPTIME"
    tput cup 8 130
    echo -ne "$SYSINFO_SHELL"
    tput cup 9 130
    echo -ne "$SYSINFO_PACKAGES"
    tput cup 10 130
    echo -ne "$SYSINFO_DE"
    tput cup 11 130
    echo -ne "$SYSINFO_WM"
    tput cup 12 130
    echo -ne "$SYSINFO_CPU"
    tput cup 13 130
    printf "${BOLD}${YELLOW}CPU Usage${RESET}:  %-5s " "${CPU_PERCENT}%"
    tput cup 13 155
    echo -ne "$CPU_BAR"
    tput cup 14 130
    echo -ne "$SYSINFO_GPU"
    tput cup 15 130
    printf "${BOLD}${YELLOW}Memory${RESET}:     %-12s " "$MEM_USAGE"
    tput cup 15 155
    echo -ne "$MEM_BAR"
    tput cup 16 130
    echo -ne "$SYSINFO_DISK"
    tput cup 17 130
    echo -ne "$SYSINFO_RESOLUTION"
    tput cup 19 130
    echo -ne "$SYSINFO_COLORS"
    
    ((img_num++))
    ((frame_count++))
    
    if [[ $img_num -gt 5 ]]; then
        img_num=1
    fi
    
    sleep .15
done
