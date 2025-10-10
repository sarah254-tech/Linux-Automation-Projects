#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Author: Sarah254-Tech
# Description: Linux System Health Audit Script for daily monitoring.

LOG_DIR="/home/sara/sys_audit"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/system_report_$(date +%F_%H-%M).log"

# Capture all output to the log

exec > >(tee -a "$LOG_FILE") 2>&1


{
echo "===== SYSTEM AUDIT REPORT ====="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo ""

echo "[1] Disk Usage:"
df -h | grep -E '^/dev/'
echo ""

echo "[2] Memory Usage:"
free -h
echo ""

echo "[3] CPU Load:"
uptime
echo ""

echo "[4] Active Services:"
systemctl list-units --type=service --state=running | head -15
echo ""

echo "[5] Network Interfaces:"
ip addr show
echo ""

echo "Audit completed successfully."
} >> "$LOG_FILE"

echo "System audit completed. Check logs in $LOG_DIR"

# === HTML EMAIL SYSTEM AUDIT REPORT ===
EMAIL="sarahamadi97@gmail.com"
SUBJECT="🌐 System Audit Report - $(date +%F_%H-%M)"
LOG_FILE="$LOG_DIR/system_report_$(date +%F).log"
HTML_FILE="$LOG_DIR/system_report_$(date +%F).html"

if [ -s "$LOG_FILE" ]; then
    echo "Building HTML report..."
    {
        echo "<html><body style='font-family:Arial,sans-serif;'>"
        echo "<h2 style='color:#2E86C1;'>🌐 System Audit Report</h2>"
        echo "<p><b>Date:</b> $(date)</p>"
        echo "<hr>"
        echo "<pre style='background:#F8F9F9;padding:10px;border-radius:6px;'>"
        cat "$LOG_FILE"
        echo "</pre>"
        echo "<hr>"
        echo "<p style='color:#16A085;'>✅ Report generated successfully by system_audit.sh</p>"
        echo "</body></html>"
    } > "$HTML_FILE"

    # Send using mutt (msmtp as backend)
    echo "Sending HTML report to $EMAIL..."
    mutt -e "set content_type=text/html" -s "$SUBJECT" -- "$EMAIL" < "$HTML_FILE"
else
    echo "No report found or log file empty."
fi


