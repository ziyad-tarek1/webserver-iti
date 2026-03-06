#!/bin/sh
# -----------------------------------------------------------------------------
# Entrypoint: Generate .htpasswd from env vars before starting Apache.
# Writes to /tmp (writable) because htdocs may be mounted read-only.
# Keeps credentials out of the image; suitable for Docker secrets / env.
# Fallback: use .htpasswd.example for local/lab use if neither env nor file exists.
# -----------------------------------------------------------------------------
set -e

# Use /tmp so we can write even when htdocs is mounted :ro
HTPASSWD_FILE="/tmp/.htpasswd"
HTACCESS_DIR="${HTACCESS_DIR:-/usr/local/apache2/htdocs/secure}"
HTPASSWD_EXAMPLE="${HTACCESS_DIR}/.htpasswd.example"

if [ -n "${HTACCESS_USERNAME}" ] && [ -n "${HTACCESS_PASSWORD}" ]; then
    echo "[entrypoint] Generating .htpasswd from HTACCESS_* env vars"
    htpasswd -cbB "$HTPASSWD_FILE" "$HTACCESS_USERNAME" "$HTACCESS_PASSWORD"
    chmod 644 "$HTPASSWD_FILE"
    chown www-data:www-data "$HTPASSWD_FILE" 2>/dev/null || true
    echo "[entrypoint] .htpasswd created for user: ${HTACCESS_USERNAME}"
elif [ ! -f "$HTPASSWD_FILE" ] && [ -f "$HTPASSWD_EXAMPLE" ]; then
    echo "[entrypoint] Using .htpasswd.example (demo credentials). For production, set HTACCESS_* or provide .htpasswd"
    cp "$HTPASSWD_EXAMPLE" "$HTPASSWD_FILE"
    chmod 644 "$HTPASSWD_FILE"
    chown www-data:www-data "$HTPASSWD_FILE" 2>/dev/null || true
fi

exec "$@"
