#!/bin/bash
set -e  # Dừng script nếu có lỗi
set -o pipefail  # Bắt lỗi trong pipeline
# Cấu hình đường dẫn
repo_url="git@github.com:vantrong2405/Project-Shopee-Clone.git"
deploy_dir="/home/vantrong/Documents/Project-Shopee-Clone"
backup_dir="/home/vantrong/Documents/shell_script/backup"
log_file="/home/vantrong/Documents/shell_script/excercise/excercise_4/logEX4_$(date +%Y%m%d).log"
frontend_dir="$deploy_dir/client"
log_info() {
    echo "[$(date +'%Y%m%d-%H:%M:%S')] $1" | tee -a "$log_file"
}
rollback() {
    log_info "Rollback: Khôi phục từ backup..."
    if [ -d "$backup_dir" ]; then
        rm -rf "$deploy_dir"
        rsync -av --exclude=node_modules "$backup_dir/" "$deploy_dir/"
        log_info "Rollback thành công!"
    else
        log_info ":warning: Không tìm thấy backup, không thể rollback!"
    fi
    exit 1
}
# Kiểm tra tham số
branch_name=$1
env=$2
if [ -z "$branch_name" ] || [ -z "$env" ]; then
    echo "Usage: $0 <branch_name> <environment>"
    exit 1
fi
log_info "Bắt đầu triển khai branch: $branch_name trên môi trường: $env"
# Tạo backup nếu deploy_dir tồn tại
if [ -d "$deploy_dir" ]; then
    log_info "Tạo backup thư mục hiện tại..."
    rm -rf "$backup_dir"
    rsync -av --exclude=node_modules "$deploy_dir/" "$backup_dir/"
else
    log_info ":warning: Không có thư mục deploy để backup!"
fi
# Xử lý lỗi
trap 'log_info "Triển khai thất bại!"; rollback' ERR SIGINT SIGTERM
# Kiểm tra repo Git
if [ ! -d "$deploy_dir/.git" ]; then
    log_info ":warning: Không tìm thấy repo, tiến hành clone..."
    rm -rf "$deploy_dir"
    git clone "$repo_url" "$deploy_dir" || { log_info "Lỗi clone repo!"; exit 1; }
fi
# Cập nhật code
git -C "$deploy_dir" fetch origin
git -C "$deploy_dir" checkout "$branch_name"
git -C "$deploy_dir" pull origin "$branch_name"

# Cài đặt dependencies cho Frontend (React)
log_info "Cài đặt dependencies frontend..."
if [ -d "$frontend_dir" ]; then
    cd "$frontend_dir"
    npm install --force | tee -a "$log_file"
    # Build Frontend
    log_info "Build frontend..."
    npm run build | tee -a "$log_file"
    # Restart Frontend
    log_info "Restart frontend service..."
    npm run dev >> "$log_file" 2>&1 &
else
    log_info ":warning: Không tìm thấy thư mục frontend!"
fi
log_info "Triển khai thành công!"