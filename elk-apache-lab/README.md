# ELK Apache Lab — Mini SOC Dashboard

**Goal:** Ingest Apache access logs into Elasticsearch with Filebeat, then build a small SOC-style dashboard in Kibana to spot 4xx activity.

## What you’ll see
- **Panel 1:** Apache events over time (@timestamp)
- **Panel 2:** Top 4xx URLs (KQL: `event.dataset:"apache.access" and http.response.status_code >= 400 and http.response.status_code < 500`)

## Architecture
- Filebeat ➜ Elasticsearch (data stream)
- Kibana (Data View, Discover, Visualizations, Dashboard)
- `docker/` — Docker Compose for Elasticsearch, Kibana, Filebeat
- `filebeat/modules.d/` — Apache module enabled + config
- `kibana-exports/export.ndjson` — saved Data View, visualizations, dashboard
- `sample-logs/apache_access.log` — test data you can replay
- `docs/screenshots/` — Discover & Dashboard screenshots


## 1. Quick start
> Requires Docker Desktop

`cd docker
docker compose up -d
`

2. Add security-safe env + gitignore
`# .env.example
ELASTIC_VERSION=8.13.4
ELASTIC_USERNAME=elastic
ELASTIC_PASSWORD=ChangeMe123!      # placeholder; set your own locally
KIBANA_SYSTEM_PASSWORD=ChangeMe123! # optional; placeholder
`

3.Add Docker Compose
Create docker/docker-compose.yml:
`version: "3.9"
services:
  elasticsearch:
    container_name: es01
    image: docker.elastic.co/elasticsearch/elasticsearch:${ELASTIC_VERSION}
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=true
      - ELASTIC_USERNAME=${ELASTIC_USERNAME}
      - ELASTIC_PASSWORD=${ELASTIC_PASSWORD}
    ports:
      - "9200:9200"
  kibana:
    container_name: kib01
    image: docker.elastic.co/kibana/kibana:${ELASTIC_VERSION}
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      - ELASTICSEARCH_USERNAME=${ELASTIC_USERNAME}
      - ELASTICSEARCH_PASSWORD=${ELASTIC_PASSWORD}
    ports:
      - "5601:5601"
    depends_on: [elasticsearch]
  filebeat:
    container_name: fb01
    image: docker.elastic.co/beats/filebeat:${ELASTIC_VERSION}
    user: root
    volumes:
      - ../filebeat/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro
      - ../filebeat/modules.d/apache.yml:/usr/share/filebeat/modules.d/apache.yml:ro
      - ../sample-logs:/usr/share/filebeat/logs:ro
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      - ELASTIC_USERNAME=${ELASTIC_USERNAME}
      - ELASTIC_PASSWORD=${ELASTIC_PASSWORD}
    depends_on: [elasticsearch, kibana]
    `
   


