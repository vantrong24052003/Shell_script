SLACK_KEY="https://hooks.slack.com/services/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"
send_slack_notification() {
  local message="Deployment failed at $(date)"
  curl -X POST -H 'Content-type: application/json' \
       --data "{\"text\": \"${message}\"}" \
       "${SLACK_KEY}"
}

send_slack_notification