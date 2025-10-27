#!/usr/bin/env bash
# backup_full.sh - Backups comprimidos con fecha
# Uso: backup_full.sh <origen> <destino> [--tag NOMBRE]
# Ej.:  backup_full.sh /www_dir /backup_dir --tag www
#       backup_full.sh /var/log /backup_dir
set -euo pipefail

show_help() {
  cat <<'EOF'
USO:
  backup_full.sh <origen> <destino> [--tag NOMBRE]

Ejemplos:
  backup_full.sh /www_dir /backup_dir --tag www
  backup_full.sh /var/log /backup_dir

Notas:
- Verifica que <origen> y <destino> existan.
- Verifica que estén montados (filesystem presente).
- Genera TAR.GZ con fecha: <tag|basename>_bkp_YYYYMMDD.tar.gz
- Registra eventos en /var/log/backup_full.log
EOF
}

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a /var/log/backup_full.log
}

# Ayuda
if [[ ${1:-} == "-h" || ${1:-} == "--help" || ${1:-} == "-help" ]]; then
  show_help
  exit 0
fi

# Parámetros
if [[ $# -lt 2 ]]; then
  show_help
  exit 1
fi

SRC="$1"
DST="$2"
TAG=""
if [[ ${3:-} == "--tag" ]]; then
  TAG="${4:-}"
fi

# Validaciones básicas
[[ -e "$SRC" ]] || { echo "ERROR: origen no existe: $SRC"; exit 2; }
[[ -d "$DST" ]] || { echo "ERROR: destino no es un directorio: $DST"; exit 3; }

# Verificar que haya un filesystem montado para origen y destino
# (findmnt devuelve info del FS donde reside la ruta)
findmnt -T "$SRC" >/dev/null 2>&1 || { echo "ERROR: origen no parece estar montado: $SRC"; exit 4; }
findmnt -T "$DST" >/dev/null 2>&1 || { echo "ERROR: destino no parece estar montado: $DST"; exit 5; }

# Preparar nombre de archivo
DATE="$(date +%Y%m%d)"
BASE="$(basename "$SRC")"
NAME="${TAG:-$BASE}_bkp_${DATE}.tar.gz"
OUT="$DST/$NAME"

log "Iniciando backup: SRC=$SRC  DST=$DST  OUT=$OUT"

# Crear el tar.gz (posicionándonos en el directorio padre de SRC)
PARENT="$(dirname "$SRC")"
ITEM="$(basename "$SRC")"

tar -C "$PARENT" -czpf "$OUT" "$ITEM"

log "Backup OK -> $OUT"
echo "Backup generado: $OUT"
