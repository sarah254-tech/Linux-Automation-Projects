#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Description: Compress local data and push to cloud storage.
SRC_DIR="/home/sarah/app_data"
DEST_DIR="/home/sarah/backups"
ARCHIVE="$DEST_DIR/backup_$(date +%F).tar.gz"

mkdir -p "$DEST_DIR"
tar -czf "$ARCHIVE" "$SRC_DIR"

# Example cloud push (replace with your cloud CLI)
# aws s3 cp "$ARCHIVE" s3://healthcare-backups/
echo "Backup complete: $ARCHIVE"
