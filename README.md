# 🧩 Linux Automation Scripts

A collection of real-world automation scripts for system monitoring and maintenance. 
These mini projects are structured with the healthcare domain in mind; however, the workflow is similar to any other scenario.

## Mini Project 1 — System Health Audit
**Script:** `system_audit.sh`  
**Purpose:** Automatically audits disk usage, memory, CPU, uptime, and active services.  
**Output:** Log file saved in `/home/sara/sys_audit/`

## ⚙️ Mini Project 2 — Automated Log Cleaner (Medium)
**Script:** `log_cleaner.sh`
**Purpose:** Automatically reduce manual overhead by deleting logs older than 7 days, freeing up storage.


## ⚙️ Mini Project 3 — API-Based Data Fetcher (Advanced)
**Objective:**
Healthcare systems often fetch external data (e.g., patient updates, analytics).
This script connects to an API, fetches JSON data, and stores it locally.

**Scripts:** `api_data_collector.sh`
**Other skills applied:** curl, jq, API integration


## Mini Project 4 — Service Availability Monitor (Complex)
**Objective:**
Monitor the uptime of critical healthcare services (e.g., app servers, DBs).
If a service is down, send an alert (e.g., email, log, or webhook).

**Script:** `service_monitor.sh`


## ⚙️ Mini Project 5 — Cloud Backup Automation (Expert-Level)
**Objective:**
Automate secure backups of application files or databases to the cloud.
This simulates real work in maintaining patient data resilience and compliance.

**Script:** `cloud_backup.sh`
