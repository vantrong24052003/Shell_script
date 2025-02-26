SENSITIVE_FILES="/home/vantrong/Documents/shell_script/excercise/excercise_9/secret.txt"


LOG_FILE="/home/vantrong/Documents/shell_script/excercise/excercise_9/log_$(date +%Y%m%d).log"

log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_and_fix_permissions() {
    for file in "${SENSITIVE_FILES[@]}"; do
        if [ -f "$file" ]; then
            CURRENT_PERM=$(stat -c "%a" "$file")
            if [ "$CURRENT_PERM" != "600" ]; then
                log_info "Phát hiện file có quyền không an toàn: $file (Quyền hiện tại: $CURRENT_PERM)"
                chmod 600 "$file"
                log_info "Đã sửa quyền file: $file -> 600"
            else
                log_info "File $file đã có quyền an toàn (600)."
            fi
        else
            log_info "File không tồn tại: $file"
        fi
    done
}

log_info "Bắt đầu kiểm tra quyền file..."
check_and_fix_permissions
log_info "Hoàn thành kiểm tra!"

exit 0
