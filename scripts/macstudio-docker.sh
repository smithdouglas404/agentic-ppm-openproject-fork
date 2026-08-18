#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env.macstudio}"
COMPOSE=(docker compose -f "$ROOT_DIR/docker-compose.yml" -f "$ROOT_DIR/docker-compose.macstudio.yml" --env-file "$ENV_FILE")

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing $ENV_FILE. Copy .env.macstudio.example to .env.macstudio and fill required values." >&2
  exit 1
fi

case "${1:-}" in
  config)
    "${COMPOSE[@]}" config --quiet
    echo "Compose configuration is valid."
    ;;
  up)
    "${COMPOSE[@]}" up -d --build
    "${COMPOSE[@]}" ps
    ;;
  status)
    "${COMPOSE[@]}" ps
    ;;
  logs)
    shift
    "${COMPOSE[@]}" logs --tail="${LOG_TAIL:-200}" "$@"
    ;;
  backup)
    backup_dir="${BACKUP_DIR:-$ROOT_DIR/backups/$(date +%Y%m%d-%H%M%S)}"
    mkdir -p "$backup_dir"
    "${COMPOSE[@]}" exec -T db pg_dump -U "${DB_USERNAME:-postgres}" "${DB_DATABASE:-openproject}" > "$backup_dir/openproject.sql"
    "${COMPOSE[@]}" exec -T governance-db mysqldump -u root -p"${MYSQL_ROOT_PASSWORD}" "${MYSQL_DATABASE:-governance}" > "$backup_dir/governance.sql"
    "${COMPOSE[@]}" stop
    docker run --rm -v "$(basename "$ROOT_DIR")_agent-kg-data:/data:ro" -v "$backup_dir:/backup" alpine:3.20 tar czf /backup/agent-kg-data.tgz -C /data .
    docker run --rm -v "$(basename "$ROOT_DIR")_agent-documents:/data:ro" -v "$backup_dir:/backup" alpine:3.20 tar czf /backup/agent-documents.tgz -C /data .
    docker run --rm -v "$(basename "$ROOT_DIR")_memgraph-data:/data:ro" -v "$backup_dir:/backup" alpine:3.20 tar czf /backup/memgraph-data.tgz -C /data .
    "${COMPOSE[@]}" start
    echo "Backup written to $backup_dir"
    ;;
  down)
    "${COMPOSE[@]}" down
    ;;
  *)
    echo "Usage: $0 {config|up|status|logs [service...]|backup|down}" >&2
    exit 2
    ;;
esac
