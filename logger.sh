#!/bin/bash

# Function to log messages with timestamps and log levels
log() {
    local message="$1"
    local log_level="$2"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [$log_level] $message" >> "$LOG_FILE"
}

# Function for log rotation
rotate_logs() {
    local max_log_size=10485760  # 10 MB (adjust as needed)
    if [ -f "$LOG_FILE" ] && [ $(stat -c %s "$LOG_FILE") -gt "$max_log_size" ]; then
        mv "$LOG_FILE" "${LOG_FILE}.old"
        log "Log file rotated." "INFO"
    fi
}

# Usage Example:
# log "This is an info message." "INFO"
# log "This is an error message." "ERROR"
# rotate_logs
