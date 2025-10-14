#!/bin/bash

CONFIG_DIR="/root/.config/internxt-cli"
INTERNXT_API="https://api.internxt.com"

echo "--- Starting Internxt CLI Service ---"
echo "Stelle sicher, dass das Konfigurationsverzeichnis existiert: ${CONFIG_DIR}"
mkdir -p "${CONFIG_DIR}"
chown -R root:root "${CONFIG_DIR}"

# --- SCHRITT 1: Internetverbindung zu Internxt als Browser getarnt testen ---
echo "Teste Verbindung zu den Internxt-Servern (${INTERNXT_API}) als Browser..."

# Wir fügen einen User-Agent hinzu, um uns als Firefox auszugeben.
HTTP_STATUS=$(curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/115.0" -s -o /dev/null -w "%{http_code}" "${INTERNXT_API}")

if [ "$HTTP_STATUS" -eq 200 ]; then
  echo "✅ VERBINDUNG ERFOLGREICH (Code: ${HTTP_STATUS})"

  # --- SCHRITT 2: Login-Versuch ---
  echo "Logging into Internxt as ${INTERNXT_EMAIL}..."
  internxt login --email "${INTERNXT_EMAIL}" --password "${INTERNXT_PASSWORD}"

  echo "Enabling WebDAV server..."
  internxt webdav enable --host 0.0.0.0 --port 7111 &

  echo "WebDAV server process started."
  echo "--- Service is now running ---"
else
  echo "❌ FEHLER: Verbindung wurde von Internxt-Servern blockiert!"
  echo "HTTP Status Code: ${HTTP_STATUS}"
  echo "Dies bestätigt ein serverseitiges Problem bei Internxt."
fi

# Hält den Container am Leben
tail -f /dev/null
