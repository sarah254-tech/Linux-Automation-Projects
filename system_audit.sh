#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Author: Sarah254-Tech
# Description: Linux System Health Audit Script for daily monitoring.

# Use environment variable if set, otherwise default to /home/sara/sys_audit
LOG_DIR="${AUDIT_LOG_DIR:-/home/sara/sys_audit}"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/$(basename "$0" .sh)_$(date +%F_%H-%M).log"
HTML_FILE="$LOG_DIR/$(basename "$0" .sh)_$(date +%F_%H-%M).html"

# FIXED: Simpler output handling without problematic pipe
{
echo "===== SYSTEM AUDIT REPORT ====="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo ""

echo "[1] Disk Usage:"
df -h | grep -E '^/dev/' || echo "No disk information available"
echo ""

echo "[2] Memory Usage:"
free -h || echo "No memory information available"
echo ""

echo "[3] CPU Load:"
uptime || echo "No uptime information available"
echo ""

echo "[4] Active Services:"
systemctl list-units --type=service --state=running 2>/dev/null | head -15 || echo "No systemd service information available"
echo ""

echo "[5] Network Interfaces:"
ip addr show 2>/dev/null || echo "No network information available"
echo ""

echo "Audit completed successfully."
} | tee "$LOG_FILE"

echo "System audit completed. Check logs in $LOG_FILE"

# Generate HTML report
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

    echo "HTML report saved to: $HTML_FILE"
else
    echo "No report found or log file empty."
fi