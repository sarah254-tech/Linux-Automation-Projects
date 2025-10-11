#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Description: Scleans old Log files older than 7 days.

LOG_DIR="/home/sara/sys_audit"
DAYS=7

find "$LOG_DIR" -type f -mtime +"$DAYS" -exec rm -f {} \;
echo "$(date): Old logs cleaned successfully from $LOG_DIR"

# Send Email
if [ -f "$LOG_DIR" ]; then
	echo "sending log cleaner report:
$LOG_FILE"
	mail -a "Content-Type: text" \ -s "Log cleaner text report" \ sarahamadi97@gmail.com < "$LOG_DIR"
else
echo "No report file found at $LOG_DIR"
fi
