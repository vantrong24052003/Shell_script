# bash excercise_7.sh /home/vantrong/Documents/shell_script/excercise/excercise_6
set -e  
set -o pipefail 
DIR_FOLDER_NEED_BACKUP=$1
DIR_BACKUP="/home/vantrong/Documents/shell_script/excercise/excercise_7/backup"
LOG_FILE="/home/vantrong/Documents/shell_script/excercise/excercise_4/log_$(date +%Y%m%d).log"

log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if [ ! -d "$DIR_FOLDER_NEED_BACKUP" ]; then
    log_info "The folder to backup does not exist.: $DIR_FOLDER_NEED_BACKUP"
    exit 1
fi

mkdir -p "$DIR_BACKUP"

BACKUP_FILE="$DIR_BACKUP/backup_$(date +%Y%m%d_%H%M%S).tar.gz"

log_info "Start backing up the folder: $DIR_FOLDER_NEED_BACKUP"
tar -czvf "$BACKUP_FILE" -C "$(dirname "$DIR_FOLDER_NEED_BACKUP")" "$(basename "$DIR_FOLDER_NEED_BACKUP")"

if [ $? -eq 0 ]; then
    log_info "Backup successful! File saved at: $BACKUP_FILE"
else
    log_info "Backup failed!"
    exit 1
fi

