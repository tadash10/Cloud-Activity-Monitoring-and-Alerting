#!/bin/bash

# Function to gracefully shut down the script
graceful_shutdown() {
    log "Shutting down Cloud Activity Monitoring and Alerting..." "INFO"
    # Implement cleanup actions if needed (e.g., close connections, save state)
    exit 0
}

# Register the graceful_shutdown function to be called on script termination
trap 'graceful_shutdown' SIGTERM SIGINT
