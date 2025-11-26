# **Newsletter List Upsert (n8n Workflow)**

## Overview

This project provides a **production-ready n8n workflow** that implements a **Newsletter List Upsert API**, which:

- Accepts an HTTP POST request  
- Validates schema  
- Computes diff between submitted emails & current subscribers  
- Supports **dry-run** vs **commit**  
- Enforces **idempotency** using `request_id`  
- Simulates **batching + 429 retry backoff**  
- Writes an **audit log**  
- Stores mock list data locally  

This README explains **how to install, run, and use** the workflow on:

1. **Local PC (Windows / macOS / Linux)**  
2. **Ubuntu Server (Docker or PM2)**  

---

# Folder Structure

Your project should follow this structure:

```
/n8n/export.json                     → Workflow file (import this into n8n)
/mnt/data/
   ├── mock/
   │   ├── lists/
   │   │   └── newsletter.json       → Mock newsletter list data
   │   └── idempotency.json          → Stores request_id results
   ├── audit/
   │   └── audit.log                 → Append-only audit log
/postman/
   ├── dry_run.sh                    → curl script for dry-run
   ├── commit.sh                     → curl script for commit
README.md
```

These paths are used by n8n Function nodes for file storage via `fs`.

---

# **1. Running n8n on Local PC (Windows / macOS / Linux)**

Ideal for development, debugging, and testing.

You can run n8n locally using:

- **Docker (Recommended)**  
- **Node.js**  

---

## **Option A: Run n8n Locally with Docker (Recommended)**

### 1. Create local data folders

```bash
mkdir -p ~/n8n-local/mnt-data
```

Copy project folders (`mock`, `audit`, etc.) into:

```
~/n8n-local/mnt-data/
```

### 2. Start n8n using Docker

```bash
docker run -it --rm   -p 5678:5678   -v ~/n8n-local/mnt-data:/mnt/data   --name n8n-newsletter   n8nio/n8n
```

### 3. Open n8n UI

```
http://localhost:5678
```

### 4. Import Workflow

**Workflows → Import → Select `n8n/export.json`**

---

## **Option B: Run n8n Locally via Node.js**

### 1. Install Node (LTS)
https://nodejs.org

### 2. Install n8n

```bash
npm install -g n8n
```

### 3. Create user folder

```bash
mkdir -p ~/n8n-data/mnt-data
```

Copy project folders into that directory.

### 4. Start n8n

```bash
export N8N_USER_FOLDER=~/n8n-data
n8n
```

### 5. Update filesystem paths (if needed)
Workflow uses paths like:

```
/mnt/data/mock/lists/newsletter.json
```

Make sure this exists on your system.

---

# 🛰️ **2. Running n8n on Ubuntu Server (Production)**

This is ideal for real usage and stable webhook processing.

Two recommended methods:

1. **Docker Compose (Recommended for Production)**  
2. **Node.js + PM2 (Advanced)**  

---

# **Option A: Ubuntu Server with Docker Compose (Recommended)**

### 1. Install Docker & Compose

```bash
sudo apt update
sudo apt install docker.io docker-compose -y
```

### 2. Create n8n directory

```bash
sudo mkdir -p /var/n8n/mnt-data
sudo chown -R $USER:$USER /var/n8n
```

Copy project folders into:

```
/var/n8n/mnt-data/
```

### 3. Create `docker-compose.yml`

```yaml
version: '3'
services:
  n8n:
    image: n8nio/n8n
    ports:
      - "5678:5678"
    volumes:
      - /var/n8n/mnt-data:/mnt/data
    environment:
      - TZ=Asia/Kolkata
    restart: always
```

### 4. Start n8n

```bash
cd /var/n8n
docker-compose up -d
```

### 5. Access UI

```
http://SERVER_IP:5678
```

---

# **Option B: Ubuntu Server with Node.js + PM2 (Advanced)**

### 1. Install Node

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
```

### 2. Install n8n

```bash
sudo npm install -g n8n
```

### 3. Prepare data folder

```bash
sudo mkdir -p /var/n8n/mnt-data
sudo chown -R $USER:$USER /var/n8n
```

### 4. Run with PM2

```bash
pm2 start n8n --name n8n
pm2 save
pm2 startup
```

### 5. Access the UI

```
http://SERVER_IP:5678
```

---

# 🔧 **Testing the API**

## Dry Run (no writes)
```
bash postman/dry_run.sh
```

## Commit (batch upsert)
```
bash postman/commit.sh
```

---

# Example Request

```json
{
  "org_id": "demo-org",
  "list_name": "Newsletter",
  "emails": ["a@akshargroup.tech", "b@akshargroup.tech"],
  "dry_run": true,
  "request_id": "2f2da2c9-0dba-4e21-bb46-d5c5e9b90310"
}
```

---

# Summary

| Method | Best For | Difficulty | Notes |
|--------|----------|------------|-------|
| **Local PC (Docker)** | Development | Easy | Recommended locally |
| **Local PC (Node.js)** | Debugging | Medium | Path setup required |
| **Ubuntu Server (Docker)** | Production | Easy-Medium | Most stable |
| **Ubuntu Server (PM2)** | Full control | Advanced | For DevOps teams |

---


