#!/bin/bash

CONFIG_DIR="/root/.config/internxt-cli"
INTERNXT_API="https://api.internxt.com"

echo "--- Starting Internxt CLI Service ---"
echo "Stelle sicher, dass das Konfigurationsverzeichnis existiert: ${CONFIG_DIR}"
mkdir -p "${CONFIG_DIR}"
chown -R root:root "${CONFIG_DIR}"

# --- SCHRITT 1: Internetverbindung zu Internxt testen ---
echo "Teste Verbindung zu den Internxt-Servern (${INTERNXT_API})..."

# Wir senden eine stille Anfrage und prüfen den HTTP-Statuscode. 200 ist Erfolg.
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${INTERNXT_API}")

if [ "$HTTP_STATUS" -eq 200 ]; then
  echo "✅ VERBINDUNG ERFOLGREICH (Code: ${HTTP_STATUS})"

  # --- SCHRITT 2: Login-Versuch (nur bei Erfolg) ---
  echo "Logging into Internxt as ${INTERNXT_EMAIL}..."
  internxt login --email "${INTERNXT_EMAIL}" --password "${INTERNXT_PASSWORD}"

  echo "Enabling WebDAV server..."
  internxt webdav enable --host 0.0.0.0 --port 7111 &

  echo "WebDAV server process started."
  echo "--- Service is now running ---"
else
  echo "❌ FEHLER: Keine Verbindung zu den Internxt-Servern möglich!"
  echo "HTTP Status Code: ${HTTP_STATUS}"
  echo "Bitte prüfen Sie die Netzwerkeinstellungen des Containers und die Firewall."
fi

# Hält den Container am Leben, damit wir die Logs lesen können
tail -f /dev/null
