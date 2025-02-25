#!/bin/bash


CLEAN_URL="$HOME/Documents/shell_script/excercise/excercise_5"
BRANCH=$1
ENVIRONMENT=$2
LOG_FILE="$CLEAN_URL/deploy.log"
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/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"
EMAIL="trong.doan@tomosia.com"

sudo apt update && sudo apt install -y curl mailutils

deploy_application() {
    echo "[INFO] Deploying branch: $BRANCH to environment: $ENVIRONMENT" | tee -a "$LOG_FILE"
    git pull origin "$BRANCH" && systemctl restart myapp.service
}

if deploy_application >> "$LOG_FILE" 2>&1; then
    echo "[SUCCESS] Deploy hoàn tất!" | tee -a "$LOG_FILE"
else
    echo "[ERROR] Deploy thất bại!" | tee -a "$LOG_FILE"
    
    curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"⚠️ Deploy thất bại! Kiểm tra log tại $LOG_FILE\"}" "$SLACK_WEBHOOK_URL"
    
    echo "Deploy thất bại! Kiểm tra log tại $LOG_FILE" | mail -s "Deploy Failed" "$EMAIL"
fi


crontab -e
0 23 * * * /bin/bash /opt/scripts/deploy.sh master production >> /var/log/deploy_cron.log 2>&1


ssh user@server "bash -s" < /opt/scripts/deploy.sh master production

