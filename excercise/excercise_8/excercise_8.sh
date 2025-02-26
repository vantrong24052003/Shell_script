#!/bin/bash

LOG_FILE="/home/vantrong/Documents/shell_script/excercise/excercise_8/log_$(date +%Y%m%d).log"
SMTP_SERVER="smtp.gmail.com"
SMTP_PORT="587"
SMTP_USERNAME="trongtk1111@gmail.com"  
SMTP_PASSWORD="yznu nuph rqkj yagy"
TO_ADDRESS="trongdn2405@gmail.com"    
FROM_ADDRESS="trongtk1111@gmail.com"   
FROM_NAME="System Monitor"             

send_email() {
    local subject="$1"
    local body="$2"
    
    swaks --to "${TO_ADDRESS}" \
          --from "${FROM_ADDRESS}" \
          --h-From: "${FROM_NAME} <${FROM_ADDRESS}>" \
          --header "Subject: ${subject}" \
          --body "${body}" \
          --server "${SMTP_SERVER}" \
          --port "${SMTP_PORT}" \
          --auth LOGIN \
          --auth-user "${SMTP_USERNAME}" \
          --auth-password "${SMTP_PASSWORD}" \
          --tls

    if [ $? -eq 0 ]; then
        echo "Email đã được gửi thành công."
    else
        echo "Gửi email thất bại. Vui lòng kiểm tra lỗi."
    fi
}

log_info() {
    echo "[$(date +'%Y%m%d-%H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

ERRORS=$(grep -E "ERROR|CRITICAL|FATAL" "$LOG_FILE" || true)
NUM_ERRORS=$(grep -c -E "ERROR|CRITICAL|FATAL" "$LOG_FILE" || true)

if [ -n "$ERRORS" ]; then
    log_info "Phát hiện lỗi nghiêm trọng trong log hệ thống!"
    
    EMAIL_SUBJECT="Cảnh báo lỗi hệ thống"
    EMAIL_BODY="Đã phát hiện $NUM_ERRORS lỗi nghiêm trọng trong log hệ thống:\n\n$ERRORS"
    
    send_email "$EMAIL_SUBJECT" "$EMAIL_BODY"

else
    log_info "Không phát hiện lỗi nghiêm trọng nào trong log hệ thống."
fi

exit 0
