#!/bin/bash
curl -s -X POST 'http://localhost:5678/webhook/newsletter/upsert' \
  -H 'Content-Type: application/json' \
  -d '{
  "org_id":"demo-org",
  "list_name":"Newsletter",
  "emails":["new1@example.com","existing1@example.com"],
  "dry_run": true,
  "request_id":"0a571646-ae51-4a08-b529-c402931afe0b"
}'
