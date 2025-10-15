#!/bin/bash

CONFIG_DIR="/root/.config/internxt-cli"
INTERNXT_API="https://api.internxt.com"

echo "--- Starting Internxt CLI Service ---"
echo "Stelle sicher, dass das Konfigurationsverzeichnis existiert: ${CONFIG_DIR}"
mkdir -p "${CONFIG_DIR}"
chown -R root:root "${CONFIG_DIR}"

# --- SCHRITT 1: Verbindungstest mit dem 'geheimen Handschlag' (HTTP Headers) ---
echo "Teste Verbindung zu den Internxt-Servern (${INTERNXT_API}) mit korrekten Headern..."

# Wir fügen die entscheidenden Header hinzu, um uns als legitimer Client auszugeben
HTTP_STATUS=$(curl -A "Mozilla/5.0" -H "Content-Type: application/json" -H "Accept: application/json" -s -o /dev/null -w "%{http_code}" "${INTERNT_API}")

if [ "$HTTP_STATUS" -eq 200 ]; then
  echo "✅ VERBINDUNG ERFOLGREICH (Code: ${HTTP_STATUS})"
  echo "Der Server hat unsere Anfrage akzeptiert. Das Problem liegt definitiv im 'internxt-cli' Tool selbst."

  # --- SCHRITT 2: Der (wahrscheinlich immer noch fehlschlagende) Login-Versuch ---
  echo "Versuche jetzt den Login mit dem internxt-cli Tool..."
  internxt login --email "${INTERNXT_EMAIL}" --password "${INTERNXT_PASSWORD}"

  # Falls der Login wider Erwarten doch klappt, starten wir den Server
  if [ $? -eq 0 ]; then
    echo "Login war erfolgreich! Starte WebDAV-Server..."
    internxt webdav enable --host 0.0.0.0 --port 7111 &
    echo "WebDAV-Server-Prozess gestartet."
  fi

else
  echo "❌ FEHLER: Selbst mit korrekten Headern wurde die Verbindung blockiert!"
  echo "HTTP Status Code: ${HTTP_STATUS}"
  echo "Dies deutet auf ein noch tieferes Problem bei Internxt hin (z.B. IP-Block)."
fi

echo "--- Service is now running (im Diagnose-Modus) ---"
tail -f /dev/null
