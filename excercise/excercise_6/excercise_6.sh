#!/bin/bash
SERVICE=$1
LOG_FILE="/home/vantrong/Documents/shell_script/excercise/excercise_6/log_$(date +%Y%m%d).log"

log_message() {
  echo "[$(date +'%Y%m%d-%H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if systemctl is-active --quiet "$SERVICE"; then
    log_message "$SERVICE is running."
else
    log_message "$SERVICE is NOT running. Attempting to restart..."
    systemctl restart "$SERVICE"
    sleep 2  
    if systemctl is-active --quiet "$SERVICE"; then
        log_message "$SERVICE restarted successfully."
    else
        log_message "Failed to restart $SERVICE."
    fi
fi
