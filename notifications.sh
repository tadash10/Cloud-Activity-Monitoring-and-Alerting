#!/bin/bash

# Function to send escalated alerts to higher-level personnel
send_escalated_alert() {
    local subject="$1"
    local message="$2"
    local escalation_email="manager@example.com"
    echo -e "$message" | mail -s "$subject" "$escalation_email"
    log "Escalated Alert sent to $escalation_email: $subject" "INFO"
}

# Function to track alert timestamps and escalate if needed
check_alerts_and_escalate() {
    local alert_time_file="/tmp/last_alert_time"
    local alert_threshold_seconds=3600  # Adjust as needed (e.g., 1 hour)

    # Check if an alert has been sent within the last hour
    if [ -f "$alert_time_file" ]; then
        local last_alert_time=$(cat "$alert_time_file")
        local current_time=$(date +%s)
        local time_since_last_alert=$((current_time - last_alert_time))

        if [ "$time_since_last_alert" -ge "$alert_threshold_seconds" ]; then
            # Send an escalated alert
            send_escalated_alert "Critical Issue Requires Attention" "A critical issue has been unresolved for over an hour."
            # Update the timestamp of the last alert
            echo "$current_time" > "$alert_time_file"
        fi
    else
        # No previous alert, so send one and create the timestamp file
        send_alert "Alert: A critical issue requires attention" "A critical issue requires attention."
        echo "$(date +%s)" > "$alert_time_file"
    fi
}

# Example: Call check_alerts_and_escalate in the monitoring loop
while true; do
    # ...
    check_alerts_and_escalate
    # ...
    sleep "$LOG_INTERVAL_SECONDS"
done
