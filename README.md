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
In this exercise data was sourced from the free URL, "https://jsonplaceholder.typicode.com/users".
 
Note that you have to have json dependencies installed.

`sudo apt install jq -y`

### **Common commands while writing an API script**

#### **API-curl command**

`curl -s` -The command-line tool for transferring data with URLs, `-s` is the silent flag - suppresses progress meters and error messages.
`curl -s -H` - including Headers. 
        - For example: `curl -s -H "Authorization: Bearer $TOKEN" "$API_URL" -o "$OUTPUT"`.
`curl -s -L` - L follows redirects.
`curl -v` - Shows connection details. Verbose output is opposite of `-s`.
`curl -s -S` - If you want to see errors despite `-s`.

#### **JSON commands**

Example: A data output of Array type
> `jq '.[] | {id, name, email}' "$OUTPUT" | head -5`

- `.[] | {id, name, email}`: The jq filter expression. `.[] ` iterates over each element in a JSON array. '|' The pipe inside jq chains filter operations together.

- `"$OUTPUT"`: The input file containing JSON data (from your previous curl command)

- `| head -5`: Pipe to show only the first 5 lines of output

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
