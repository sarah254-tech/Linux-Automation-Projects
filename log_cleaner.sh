#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Description: Cleans old Log files older than 7 days.

LOG_DIR="/home/sara/sys_audit"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/$(basename "$0" .sh)_$(date +%F).log"
HTML_FILE="$LOG_DIR/$(basename "$0" .sh)_$(date +%F).html"
DAYS=7
EMAIL="sarahamadi97@gmail.com"
SUBJECT="Log Cleaner Report - $(date +%F_%H-%M)"

# Capture output
exec > >(tee -a "$LOG_FILE") 2>&1

find "$LOG_FILE" -type f -mtime +"$DAYS" -exec rm -f {} \;
echo "$(date): Old logs cleaned successfully from $LOG_FILE" >> "$LOG_FILE"


# HTML  report
{
	echo "<html><body style='font-family:Arial;'>"
    echo "<h2 style='color:#2E86C1;'>🧹 Log Cleaner Report</h2>"
    echo "<p><b>Date:</b> $(date)</p><hr>"
    echo "<pre style='background:#F8F9F9;padding:10px;border-radius:6px;'>"
    cat "$LOG_FILE"
    echo "</pre><hr>"
    echo "<p style='color:#16A085;'>✅ Log cleaner completed successfully.</p>"
    echo "</body></html>"
} > "$HTML_FILE"

# Send Email
if [ -s "$HTML_FILE" ]; then
	echo "sending log cleaner report:$HTML_FILE"

	mutt -e "set content_type=text/html" -s "$SUBJECT" -- "$EMAIL" < "$HTML_FILE"
	echo "Email sent to $EMAIL"

else

echo "No report file found at $LOG_DIR"

fi
