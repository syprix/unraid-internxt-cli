#!/bin/bash

CONFIG_DIR="/root/.config/internxt-cli"
PING_TARGET="8.8.8.8" # Eine zuverlässige IP (Google DNS)

echo "--- Starting Internxt CLI Service ---"

# --- SCHRITT 1: Internetverbindung mit Ping testen ---
echo "Teste Internetverbindung durch Ping an ${PING_TARGET}..."

# Wir senden 4 Pings und warten maximal 10 Sekunden
if ping -c 4 -W 10 "${PING_TARGET}"; then
  echo "✅ INTERNETVERBINDUNG ERFOLGREICH."

  # --- SCHRITT 2: Login-Prozess (nur bei Erfolg) ---
  echo "Stelle sicher, dass das Konfigurationsverzeichnis existiert: ${CONFIG_DIR}"
  mkdir -p "${CONFIG_DIR}"
  chown -R root:root "${CONFIG_DIR}"

  echo "Logging into Internxt as ${INTERNXT_EMAIL}..."
  internxt login --email "${INTERNXT_EMAIL}" --password "${INTERNXT_PASSWORD}"

  echo "Enabling WebDAV server..."
  internxt webdav enable --host 0.0.0.0 --port 7111 &

  echo "WebDAV server process started."
  echo "--- Service is now running ---"
else
  echo "❌ FEHLER: Keine Internetverbindung!"
  echo "Der Ping an ${PING_TARGET} ist fehlgeschlagen."
  echo "Der Container hat keine funktionierende Verbindung zum Internet."
fi

# Hält den Container am Leben, damit wir die Logs lesen können
tail -f /dev/null
