#!/usr/bin/env bash

### NOTE 1 Как помню, 'test' это системная команда для проверки условий, поэтому имя процесса выбрал как 'testp'.

PNAME="testp"
LOG_FILE=/var/log/monitoring.log
PID_FILE="$HOME"/testp.pid

if [ ! -f "$PID_FILE" ]; then
  touch "$PID_FILE"
fi

if [ ! -f "$LOG_FILE" ]; then
  touch "$LOG_FILE"
fi

get_pid() {
  pgrep -f "$PNAME"
}

curr_date() {
  date "+%Y-%m-%d %H:%M:%S"
}

### Check PID
CURRENT_PID=$(get_pid)

if [ -z "$CURRENT_PID" ]; then
  exit 0
fi

if [ ! -s "$PID_FILE" ]; then  # At first start
  echo "$CURRENT_PID" > "$PID_FILE"
fi

OLD_PID=$(cat "$PID_FILE")

if [ "$CURRENT_PID" != "$OLD_PID" ]; then
  echo "[WARN] [$(curr_date)] The process was restarted with new pid: '$CURRENT_PID'!" >> "$LOG_FILE"
  echo "$CURRENT_PID" > "$PID_FILE"
fi

### GET REQUEST
CONTENT=$(curl --connect-timeout 5 -f -sS -X GET https://test.com/monitoring/test/api 2>&1)

if echo "$CONTENT" | grep -q "Connection timed out"; then
  echo "DEBUG FROM TIMEOUT"
  echo "[ERROR] [$(curr_date)] $CONTENT" >> "$LOG_FILE"
elif echo "$CONTENT" | grep -q "The requested URL returned error:"; then
  echo "[ERROR] [$(curr_date)] $CONTENT" >> "$LOG_FILE"
fi

