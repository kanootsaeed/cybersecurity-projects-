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
## Repository layout

```text
elk-apache-lab/
├─ docker/
│  └─ docker-compose.yml
├─ filebeat/
│  ├─ filebeat.yml
│  └─ modules.d/
│     └─ apache.yml
├─ sample-logs/
│  └─ apache_access.log
├─ kibana-exports/
│  └─ export.ndjson
├─ docs/
│  └─ screenshots/
│     ├─ discover.png
│     └─ dashboard.png
├─ .env.example
├─ .gitignore
└─ README.md
```


## 1. Quick start
> Requires Docker Desktop

```
cd docker
docker compose up -d
```

### 2. Environment
This repo includes a sample env file. Copy it locally and edit your own values:

```bash
cp .env.example .env
# open .env and set your passwords locally (this file is git-ignored)
```

```md
### 3. Add Docker Compose

Create `docker/docker-compose.yml`:

```yaml
version: "3.9"
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
```
4. Add minimal Filebeat config + Apache module
```
Create filebeat/filebeat.yml and filebeat/modules.d/apache.yml:
# filebeat/filebeat.yml
filebeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  reload.enabled: false

output.elasticsearch:
  hosts: ["http://elasticsearch:9200"]
  username: ${ELASTIC_USERNAME}
  password: ${ELASTIC_PASSWORD}

setup.kibana:
  host: "http://kibana:5601"
  username: ${ELASTIC_USERNAME}
  password: ${ELASTIC_PASSWORD}

setup.ilm.enabled: auto
```
```
# filebeat/modules.d/apache.yml
- module: apache
  access:
    enabled: true
    var.paths:
      - /usr/share/filebeat/logs/apache_access.log*
```
5. Seed test data quickly
Create sample-logs/apache_access.log and drop a few lines (or generate):
```
# few static lines
printf '%s "GET /wp-login.php HTTP/1.1" 401 245 "-" "curl/8.1.0"\n' "$(date '+%d/%b/%Y:%H:%M:%S %z')" >> sample-logs/apache_access.log
printf '%s "GET /about HTTP/1.1" 200 532 "-" "Mozilla/5.0"\n'       "$(date '+%d/%b/%Y:%H:%M:%S %z')" >> sample-logs/apache_access.log

# small burst generator
for p in /admin /server-status /phpmyadmin /wp-login.php; do
  code=$(( (RANDOM % 3)*100 + 200 ))
  printf '%s "GET %s HTTP/1.1" %s 312 "-" "Mozilla/5.0"\n' \
    "$(date '+%d/%b/%Y:%H:%M:%S %z')" "$p" "$code" >> sample-logs/apache_access.log
done
```
Then restart Filebeat only (if already running):
docker compose -f docker/docker-compose.yml restart filebeat




   


