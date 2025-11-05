#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Description: Cleans old Log files older than 7 days.

LOG_DIR="${AUDIT_LOG_DIR:-/home/sara/sys_audit}"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/$(basename "$0" .sh)_$(date +%F).log"
HTML_FILE="$LOG_DIR/$(basename "$0" .sh)_$(date +%F).html"
DAYS=7

# FIXED: Removed problematic exec line and use simpler logging

{
echo "===== LOG CLEANER REPORT ====="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo ""

echo "Cleaning logs older than $DAYS days from: $LOG_DIR"
find "$LOG_DIR" -name "*.log" -type f -mtime +"$DAYS" -exec rm -f {} \; 2>/dev/null || echo "No old logs found to clean"
find "$LOG_DIR" -name "*.html" -type f -mtime +"$DAYS" -exec rm -f {} \; 2>/dev/null || echo "No old HTML files found to clean"

echo ""
echo "Log cleaner completed successfully."
} | tee "$LOG_FILE"

# HTML report
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

echo "HTML report generated at: $HTML_FILE"
echo "Email notification disabled in Jenkins environment"