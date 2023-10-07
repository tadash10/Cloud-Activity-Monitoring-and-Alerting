#!/bin/bash

# Load configuration from config.json
if [ -f "config.json" ]; then
    source <(jq -r '. | to_entries | .[] | "export " + .key + "=\"" + (.value|tostring) + "\"" ' config.json)
else
    echo "Error: Configuration file 'config.json' not found."
    exit 1
fi

# Function to log messages with timestamps and log levels
log() {
    local message="$1"
    local log_level="$2"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [$log_level] $message" >> "$LOG_FILE"
}

# Function to send alerts
send_alert() {
    local subject="$1"
    local message="$2"
    echo -e "$message" | mail -s "$subject" "$ADMIN_EMAIL"
    log "Alert sent: $subject" "INFO"
}

# Function to analyze cloud activity logs
analyze_logs() {
    while true; do
        log "Checking $CLOUD_PROVIDER $LOG_SOURCE logs..." "INFO"
        
        # Fetch log entries and handle errors
        log_entries=$(your_log_query_command_here)
        if [ $? -ne 0 ]; then
            log "Error fetching log entries." "ERROR"
            sleep "$LOG_INTERVAL_SECONDS"
            continue
        fi

        suspicious_activity_count=$(echo "$log_entries" | grep -c "suspicious_pattern")

        if [ "$suspicious_activity_count" -ge "$ALERT_THRESHOLD" ]; then
            subject="Suspicious Activities Detected in $CLOUD_PROVIDER $LOG_SOURCE Logs"
            send_alert "$subject" "$log_entries"
        fi

        sleep "$LOG_INTERVAL_SECONDS"
    done
}

# Main script execution
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 [start|stop]"
    exit 1
fi

if [ "$1" == "start" ]; then
    log "Cloud Activity Monitoring and Alerting started." "INFO"
    analyze_logs
elif [ "$1" == "stop" ]; then
    log "Cloud Activity Monitoring and Alerting stopped." "INFO"
else
    echo "Usage: $0 [start|stop]"
    exit 1
fi
