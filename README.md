
Newsletter List Upsert


Files:
- /n8n/export.json         -> n8n workflow export (import into n8n)
- /mock/lists/newsletter.json
- /mock/idempotency.json
- /audit/audit.log
- /postman/dry_run.sh
- /postman/commit.sh
- README.md

How to import:
1) In n8n, go to Workflows -> Import from file -> upload n8n/export.json
2) Ensure n8n has filesystem access to the paths used in Function nodes (/mnt/data/...)
   - If n8n runs in Docker, mount a host directory to the container (e.g. '-v /path/on/host/mnt/data:/mnt/data')
3) Start the workflow and POST to the webhook path shown by n8n (typically /webhook/newsletter/upsert)

Notes & Caveats:
1) Function nodes use Node's 'fs' module to read/write mock files at /mnt/data/mock/...
   - On self-hosted n8n (Linux) this path is available.
   - If your n8n is running in Docker, mount a host folder to the container and update paths.
2) If your n8n environment disallows 'require' in Function nodes, replace the Function nodes with:
   - HTTP Request nodes pointing to a tiny mock server (e.g., Express) that exposes endpoints for:
     /mock/lists/newsletter.json (GET/PUT), /mock/idempotency.json (GET/PUT), /audit (POST append).
3) The webhook path is: POST /webhook/newsletter/upsert  (n8n base path may differ)
4) The package implements: Schema validation, idempotency, diff calc, dry-run, batching simulation, audit log.

CURL examples in /postman/*.sh
