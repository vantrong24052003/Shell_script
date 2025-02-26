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
                log_info "Detect files with unsafe permissions: $file (Current permit: $CURRENT_PERM)"
                chmod 600 "$file"
                log_info "Fixed file permissions: $file -> 600"
            else
                log_info "File $file has the right to safety (600)."
            fi
        else
            log_info "File does not exist: $file"
        fi
    done
}

log_info "Start checking file permissions..."
check_and_fix_permissions
log_info "Test completed!"

exit 0
