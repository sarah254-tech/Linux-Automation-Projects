#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Author: Sarah254-Tech
# Description: Linux System Health Audit Script for daily monitoring.

LOG_DIR="/home/sara/sys_audit"
LOG_FILE="$LOG_DIR/system_report_$(date +%F_%H-%M).log"

mkdir -p "$LOG_DIR"

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

