# /home/vantrong/Documents/shell_script/excercise/excercise_6
SERVICE=$1
LOG_FILE="/home/vantrong/Documents/shell_script/excercise/excercise_7/log_$(date +%Y%m%d).log"
PATH_EXCERCISE_7="/home/vantrong/Documents/shell_script/excercise/excercise_7"

log_info() {
  echo "[$(date +'%Y%m%d-%H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if [ -f "$PATH_EXCERCISE_7/excercise_7.sh" ]; then
   log_info "Found script for lesson 7. Executing..."
   bash "$PATH_EXCERCISE_7/excercise_7.sh" "$SERVICE"
else
   log_info "Lesson 7 script not found! Check the path again."
   exit 1
fi

FILE_BACKUP=$(ls -t "$PATH_EXCERCISE_7/backup/"backup_*.tar.gz 2>/dev/null | head -n 1)

if [ -n "$FILE_BACKUP" ]; then
    log_info "File backup: $FILE_BACKUP exist."
else
    log_info "Backup file not found!"
    exit 1
fi

