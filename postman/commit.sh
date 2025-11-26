#!/bin/bash
curl -s -X POST 'http://localhost:5678/webhook/newsletter/upsert' \
  -H 'Content-Type: application/json' \
  -d '{
  "org_id":"demo-org",
  "list_name":"Newsletter",
  "emails":["new1@example.com","new2@example.com"],
  "dry_run": false,
  "request_id":"4b037d04-a502-4e15-9ac7-80e7883c3ede"
}'
