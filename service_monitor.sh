#!/bin/bash
set -eou pipefail
IFS=$'\n't'


# Description: Monitors key services and notifies admin if any are down.
SERVICES=("nginx" "docker")
LOG="/var/log/sys_audit"

echo "===== SERVICE STATUS REPORT $(date) =====" >> "$LOG"

for service in "${SERVICES[@]}"; do
  if systemctl is-active --quiet "$service"; then
    echo "$service: RUNNING" >> "$LOG"
  else
    echo "$service: DOWN" >> "$LOG"
    # Optional: send alert 
    echo "ALERT: $service is DOWN at $(date)"
  fi
done

echo "Report logged to $LOG"

