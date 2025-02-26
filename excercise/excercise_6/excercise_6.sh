SERVICE=$1
LOG_FILE="/home/vantrong/Documents/shell_script/excercise/excercise_6/log_$(date +%Y%m%d).log"

log_info() {
  echo "[$(date +'%Y%m%d-%H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if systemctl is-active --quiet "$SERVICE"; then
    log_info "$SERVICE is running."
else
    log_info "$SERVICE is NOT running. Attempting to restart..."
    systemctl restart "$SERVICE"
    if systemctl is-active --quiet "$SERVICE"; then
        log_info "$SERVICE restarted successfully."
    else
        log_info "Failed to restart $SERVICE."
    fi
fi

