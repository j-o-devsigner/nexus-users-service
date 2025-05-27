#!/bin/bash
set -e
HOST="${DB_HOST:-db-nexus}"
USER="${DB_USER:-postgres}"
DB="${DB_NAME:-postgres}"
PORT="${DB_PORT:-5432}"
PASSWORD="${DB_PASSWORD:-postgres}"
SQL_FILES=("01_create_tables.sql" "02_triggers.sql" "03_inserts.sql")

export PGPASSWORD="$PASSWORD"

echo "Esperando a que la base de datos esté disponible..."
until pg_isready -h "$HOST" -p "$PORT" -U "$USER"; do
  sleep 2
done

echo "Ejecutando scripts de inicialización..."
for SQL_FILE in "${SQL_FILES[@]}"; do
  if [[ -f "$SQL_FILE" ]]; then
    echo "Ejecutando $SQL_FILE..."
    psql -h "$HOST" -U "$USER" -d "$DB" -p "$PORT" -f "$SQL_FILE"
    if [[ $? -ne 0 ]]; then
      echo "Error ejecutando $SQL_FILE. Abortando."
      unset PGPASSWORD
      exit 1
    fi
  else
    echo "Archivo $SQL_FILE no encontrado, saltando."
  fi
done

unset PGPASSWORD
echo "¡Todos los scripts ejecutados correctamente!"
