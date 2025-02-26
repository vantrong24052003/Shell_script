set -e  
set -o pipefail 

DIR_FOLDER_NEED_BACKUP="/home/vantrong/Documents/shell_script/excercise/excercise_6"
DIR_BACKUP="/home/vantrong/Documents/shell_script/excercise/excercise_7/backup"
LOG_FILE="/home/vantrong/Documents/shell_script/excercise/excercise_4/log_$(date +%Y%m%d).log"

log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if [ ! -d "$DIR_FOLDER_NEED_BACKUP" ]; then
    log_info "Thư mục cần backup không tồn tại: $DIR_FOLDER_NEED_BACKUP"
    exit 1
fi

mkdir -p "$DIR_BACKUP"

BACKUP_FILE="$DIR_BACKUP/backup_$(date +%Y%m%d_%H%M%S).tar.gz"

log_info "Bắt đầu backup thư mục: $DIR_FOLDER_NEED_BACKUP"
tar -czvf "$BACKUP_FILE" -C "$(dirname "$DIR_FOLDER_NEED_BACKUP")" "$(basename "$DIR_FOLDER_NEED_BACKUP")"

if [ $? -eq 0 ]; then
    log_info "Backup thành công! File lưu tại: $BACKUP_FILE"
else
    log_info "Backup thất bại!"
    exit 1
fi

