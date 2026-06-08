set -e

DB_PATH="${SQLITE_PATH:-/app/backend/tp/db.sqlite3}"
DB_DIR="$(dirname "$DB_PATH")"

mkdir -p "$DB_DIR"

if [ ! -f "$DB_PATH" ] && [ -f /app/backend/tp/db.sqlite3 ]; then
  cp /app/backend/tp/db.sqlite3 "$DB_PATH"
fi

python manage.py migrate --noinput

exec "$@"
