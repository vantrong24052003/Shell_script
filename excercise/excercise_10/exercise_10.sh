# /home/vantrong/Documents/shell_script/excercise/excercise_6
SERVICE=$1
LOG_FILE="/home/vantrong/Documents/shell_script/excercise/excercise_7/log_$(date +%Y%m%d).log"
PATH_EXCERCISE_7="/home/vantrong/Documents/shell_script/excercise/excercise_7"

log_info() {
  echo "[$(date +'%Y%m%d-%H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if [ -f "$PATH_EXCERCISE_7/excercise_7.sh" ]; then
   log_info "Tìm thấy script bài 7. Đang thực thi..."
   bash "$PATH_EXCERCISE_7/excercise_7.sh" "$SERVICE"
else
   log_info "Không tìm thấy script bài 7! Kiểm tra lại đường dẫn."
   exit 1
fi

FILE_BACKUP=$(ls -t "$PATH_EXCERCISE_7/backup/"backup_*.tar.gz 2>/dev/null | head -n 1)

if [ -n "$FILE_BACKUP" ]; then
    log_info "File backup: $FILE_BACKUP tồn tại."
else
    log_info "Không tìm thấy file backup!"
    exit 1
fi

