set -e
set -o pipefail

REPO_CLONE_SSH="https://github.com/vantrong24052003/Shopee-Clone.git"
DIR_PROJECT="/home/vantrong/Documents/Shopee-Clone"
DIR_BACKUP="/home/vantrong/Documents/shell_script/excercise/excercise_4/backup"
LOG_FILE="/home/vantrong/Documents/shell_script/excercise/excercise_4/log_$(date +%Y%m%d).log"
branch_name=$1
env=$2

if [ -z "$branch_name" ] || [ -z "$env" ]; then
    echo "Usage: <branch_name> <environment>"
    exit 1
fi

log_info() {
    echo "[$(date +'%Y%m%d-%H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

rollback() {
    log_info "Rollback: Restore from backup..."
    if [ -d "$DIR_BACKUP" ]; then
        rm -rf "$DIR_PROJECT"
        rsync -av --exclude=node_modules "$DIR_BACKUP/" "$DIR_PROJECT/"
        log_info "Deploy failed and Rollback successful!"
    else
        log_info ":warning: Backup not found, cannot rollback!"
    fi
    exit 1
}

if [ -z "$branch_name" ] || [ -z "$env" ]; then
    echo "Usage: $0 <branch_name> <environment>"
    exit 1
fi
log_info "Start deploying branch: $branch_name on the environment: $env"

if [ -d "$DIR_PROJECT" ]; then
    log_info "Create backup of current directory..."
    rm -rf "$DIR_BACKUP"
    rsync -av --exclude=node_modules "$DIR_PROJECT/" "$DIR_BACKUP/"
else
    log_info ":warning: There is no deploy folder to backup!"
fi

trap 'log_info "Triển khai thất bại!"; rollback' ERR SIGINT SIGTERM

if [ ! -d "$DIR_PROJECT/.git" ]; then
    log_info ":warning: Repo not found, clone..."
    rm -rf "$DIR_PROJECT"
    git clone "$REPO_CLONE_SSH" "$DIR_PROJECT" || {
        log_info "Error cloning repo!"
        exit 1
    }
fi

git -C "$DIR_PROJECT" fetch origin
git -C "$DIR_PROJECT" checkout "$branch_name"
git -C "$DIR_PROJECT" pull origin "$branch_name"

log_info "Install dependencies..."
if [ -d "$DIR_PROJECT" ]; then
    cd "$DIR_PROJECT"
    npm install --force >>"$LOG_FILE" 2>&1 || rollback

    log_info "Build..."
    npm run build | tee -a "$LOG_FILE"

    log_info "Restart service..."
    pm2 start npm --name "Shopee-Clone" -- run dev
else
    log_info ":warning: Found not found!"
fi
log_info "Deploy success!"
