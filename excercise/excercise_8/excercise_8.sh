LOG_FILE="/home/vantrong/Documents/shell_script/excercise/excercise_8/log_$(date +%Y%m%d).log"
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/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"

send_slack_notification() {
    local message="[$(date +'%Y%m%d-%H:%M:%S')]$1"
    curl -X POST -H 'Content-type: application/json' \
        --data "{\"text\": \"${message}\"}" \
        "${SLACK_WEBHOOK_URL}"
}

log_info() {
    echo "[$(date +'%Y%m%d-%H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

ERRORS=$(grep -E "ERROR|CRITICAL|FATAL" "$LOG_FILE" || true)
NUM_ERRORS=$(grep -c -E "ERROR|CRITICAL|FATAL" "$LOG_FILE" || true)

if [ -n "$ERRORS" ]; then
    log_info "Phát hiện lỗi nghiêm trọng trong log hệ thống!"
    send_slack_notification "Đã phát hiện $NUM_ERRORS lỗi nghiêm trọng.\n$ERRORS"

    if [ $? -eq 0 ]; then
        log_info "Thông báo đã được gửi thành công."
    else
        log_info "Gửi thông báo thất bại!"
    fi
else
    log_info "Không phát hiện lỗi nghiêm trọng nào trong log hệ thống."
fi

exit 0
