# ELK Apache Lab — Mini SOC Dashboard

**Goal:** Ingest Apache access logs into Elasticsearch with Filebeat, then build a small SOC-style dashboard in Kibana to spot 4xx activity.

## What you’ll see
- **Panel 1:** Apache events over time (@timestamp)
- **Panel 2:** Top 4xx URLs (KQL: `event.dataset:"apache.access" and http.response.status_code >= 400 and http.response.status_code < 500`)

## Architecture
Filebeat → Elasticsearch (data stream) → Kibana (Data View, Discover, Visualizations, Dashboard)
docker/ # compose for Elasticsearch, Kibana, Filebeat
filebeat/modules.d/ # apache module enabled/configured
kibana-exports/export.ndjson # saved data view, visualizations, dashboard
sample-logs/apache_access.log # test data you can replay
docs/screenshots/ # screenshots of Discover & Dashboard


## Quick start
> Requires Docker Desktop

1. **Start the stack**
   ```bash
   docker compose -f docker/docker-compose.yml up -d
