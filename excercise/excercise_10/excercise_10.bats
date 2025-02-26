#!/usr/bin/env bats

SERVICE="apache2"
LOG_FILE="/home/vantrong/Documents/shell_script/excercise/excercise_10/log_$(date +%Y%m%d).log"

setup() {
  rm -f "$LOG_FILE"
}

@test "Service is running" {
  run bash -c "systemctl is-active --quiet $SERVICE && echo '$SERVICE is running.' >> $LOG_FILE"
  grep "$SERVICE is running." "$LOG_FILE"
}

@test "Service is NOT running and restarts successfully" {
  run bash -c "systemctl stop $SERVICE; systemctl restart $SERVICE; sleep 2; systemctl is-active --quiet $SERVICE && echo '$SERVICE restarted successfully.' >> $LOG_FILE"
  grep "$SERVICE restarted successfully." "$LOG_FILE"
}

@test "Service restart fails" {
  run bash -c "systemctl stop $SERVICE; false || echo 'Failed to restart $SERVICE.' >> $LOG_FILE"
  grep "Failed to restart $SERVICE." "$LOG_FILE"
}
