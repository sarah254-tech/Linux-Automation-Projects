#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Author: Sarah254-Tech
# Description: Monitors key services and notifies admin if any are down.

SERVICES=("nginx" "docker")
LOG_DIR="${AUDIT_LOG_DIR:-/home/sara/sys_audit}"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/$(basename "$0" .sh)_$(date +%F_%H-%M).log"

echo "===== SERVICE STATUS REPORT $(date) =====" >> "$LOG_FILE"

for service in "${SERVICES[@]}"; do
  if systemctl is-active --quiet "$service"; then
    echo "$service: RUNNING" >> "$LOG_FILE"
  else
    echo "$service: DOWN" >> "$LOG_FILE"
    # Optional: send alert 
    echo "ALERT: $service is DOWN at $(date)"
  fi
done

echo "Report logged to $LOG_FILE"


