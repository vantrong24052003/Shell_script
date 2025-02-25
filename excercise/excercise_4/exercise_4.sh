set -e
set -o pipefail
REPO_CLONE_SSH="https://github.com/vantrong24052003/Shopee-Clone.git"
DIR_DEPLOY="/home/vantrong/Documents/Shopee-Clone"
DIR_BACKUP="/home/vantrong/Documents/shell_script/excercise/excercise_4/backup"
LOG_FILE="/home/vantrong/Documents/shell_script/excercise/excercise_4/log1_$(date +%Y%m%d).log"
branch_name=$1
env=$2

log_info() {
    echo "[$(date +'%Y%m%d-%H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

rollback() {
    log_info "Rollback: Khôi phục từ backup..."
    if [ -d "$DIR_BACKUP" ]; then
        rm -rf "$DIR_DEPLOY"
        rsync -av --exclude=node_modules "$DIR_BACKUP/" "$DIR_DEPLOY/"
        log_info "Rollback thành công!" 
    else
        log_info ":warning: Không tìm thấy backup, không thể rollback!"
    fi
    exit 1
}

if [ -z "$branch_name" ] || [ -z "$env" ]; then
    echo "Usage: $0 <branch_name> <environment>"
    exit 1
fi
log_info "Bắt đầu triển khai branch: $branch_name trên môi trường: $env"

if [ -d "$DIR_DEPLOY" ]; then
    log_info "Tạo backup thư mục hiện tại..."
    rm -rf "$DIR_BACKUP"
    rsync -av --exclude=node_modules "$DIR_DEPLOY/" "$DIR_BACKUP/"
else
    log_info ":warning: Không có thư mục deploy để backup!"
fi

trap 'log_info "Triển khai thất bại!"; rollback' ERR SIGINT SIGTERM

if [ ! -d "$DIR_DEPLOY/.git" ]; then
    log_info ":warning: Không tìm thấy repo, tiến hành clone..."
    rm -rf "$DIR_DEPLOY"
    git clone "$REPO_CLONE_SSH" "$DIR_DEPLOY" || {
        log_info "Lỗi clone repo!"
        exit 1
    }
fi

git -C "$DIR_DEPLOY" fetch origin
git -C "$DIR_DEPLOY" checkout "$branch_name"
git -C "$DIR_DEPLOY" pull origin "$branch_name"

log_info "Cài đặt dependencies frontend..."
if [ -d "$DIR_DEPLOY" ]; then
    cd "$DIR_DEPLOY"
   npm install --force >> "$LOG_FILE" 2>&1 || rollback

    log_info "Build frontend..."
    npm run build | tee -a "$LOG_FILE"

    log_info "Restart service..."
    npm run dev >>"$LOG_FILE" 2>&1 &
else
    log_info ":warning: Không tìm thấy thư mục!"
fi
log_info "Triển khai thành công!"
