#!/bin/bash
SLACK_KEY="https://hooks.slack.com/services/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"
send_slack_notification() {
  local message="$1"
  curl -X POST -H 'Content-type: application/json' \
       --data "{\"text\": \"${message}\"}" \
       "${SLACK_KEY}"
}
send_slack_notification "Deployment thất bại vào lúc $(date)"