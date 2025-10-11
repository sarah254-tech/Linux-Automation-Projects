#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Description: Cleans old Log files older than 7 days.

LOG_DIR="/home/sara/sys_audit"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/log_cleaner_$(date +%F).log"
DAYS=7
EMAIL="sarahamadi97@gmail.com"
SUBJECT="Log CLeaner Report - $(date +%F_%H-%M)"

# Capture output
exec > >(tee -a "$LOG_FILE") 2>&1

find "$LOG_FILE" -type f -mtime +"$DAYS" -exec rm -f {} \;
echo "$(date): Old logs cleaned successfully from $LOG_FILE" > "$LOG_DIR/log_cleaner_report.txt"

# Send Email
if [ -s "$LOG_FILE" ]; then
	echo "sending log cleaner report:$LOG_FILE"

	mail -a "Content-Type: text/html" \ -s "$SUBJECT" \ "$EMAIL" < "$LOG_DIR/log_cleaner_report.log"
	echo "Email sent to $EMAIL"

else

echo "No report file found at $LOG_DIR"

fi
