#!/bin/bash
set -e
set -o pipefail

CLEAN_URL="$HOME/Documents/shell_script/excercise/excercise_4"
LOGFILE="$CLEAN_URL/deploy_$(date +%Y%m%d).log"
BACKUP_DIR="$CLEAN_URL/backend_backup_$(date +%Y%m%d_%H%M%S)"
DEPLOY_DIR="$CLEAN_URL/backend"
BRANCH_NAME=$1
ENVIRONMENT=$2

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

rollback_function() {
    log_info "Rollback: Khôi phục từ backup $BACKUP_DIR"
    rm -rf "$DEPLOY_DIR"
    cp -r "$BACKUP_DIR" "$DEPLOY_DIR"
    nohup npm start > "$DEPLOY_DIR/backend.log" 2>&1 &
    exit 1
}

if [ -z "$BRANCH_NAME" ] || [ -z "$ENVIRONMENT" ]; then
    echo "Usage: $0 <branch_name> <environment>"
    exit 1
fi

if [ ! -d "$DEPLOY_DIR" ]; then
    log_info ">>>>>Thư mục $DEPLOY_DIR không tồn tại, tạo mới thư mục"
    mkdir -p "$DEPLOY_DIR"
fi

trap 'log_info "Deploy bị gián đoạn"; rollback_function' ERR SIGINT SIGTERM

log_info "Bắt đầu deploy branch $BRANCH_NAME cho môi trường $ENVIRONMENT"

log_info "Backup thư mục backend vào $BACKUP_DIR"
cp -r "$DEPLOY_DIR" "$BACKUP_DIR"

log_info "Pull code từ Git..."

# git pull origin "$BRANCH_NAME" >> "$LOGFILE" 2>&1

log_info "Build dự án..."
# mvn clean package >> "$LOGFILE" 2>&1

log_info "Chạy test..."
# ./run_tests.sh >> "$LOGFILE" 2>&1

log_info "Restart backend-service..."
# systemctl restart backend-service >> "$LOGFILE" 2>&1
log_info "Deploy thành công!"