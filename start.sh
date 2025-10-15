#!/bin/bash

# --- KONFIGURATION ---
CONFIG_DIR="/root/.config/internxt-cli"
PING_TARGET="8.8.8.8"
INTERNXT_API="https://api.internxt.com"

echo "--- Starting Internxt CLI Service ---"
echo "Stelle sicher, dass das Konfigurationsverzeichnis existiert: ${CONFIG_DIR}"
mkdir -p "${CONFIG_DIR}"
chown -R root:root "${CONFIG_DIR}"

# --- SCHRITT 1: PING-TEST (Internetverbindung allgemein) ---
echo "Teste Internetverbindung durch Ping an ${PING_TARGET}..."
if ping -c 4 -W 10 "${PING_TARGET}"; then
  echo "✅ PING ERFOLGREICH. Container hat Internetzugang."

  # --- SCHRITT 2: HANDSHAKE-TEST (Spezifische Verbindung zu Internxt) ---
  echo "Teste Handshake mit Internxt-Server (${INTERNXT_API})..."
  HTTP_STATUS=$(curl -A "Mozilla/5.0" -H "Content-Type: application/json" -H "Accept: application/json" -s -o /dev/null -w "%{http_code}" "${INTERNXT_API}")

  if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✅ HANDSHAKE ERFOLGREICH (Code: ${HTTP_STATUS}). Internxt-Server antwortet korrekt."

    # --- SCHRITT 3: LOGIN-VERSUCH (Nur bei Erfolg) ---
    echo "Versuche jetzt den automatischen Login..."
    internxt login --email "${INTERNXT_EMAIL}" --password "${INTERNXT_PASSWORD}"

    # Prüfen, ob der Login-Befehl erfolgreich war
    if [ $? -eq 0 ]; then
      echo "✅ LOGIN ERFOLGREICH. Starte WebDAV-Server..."
      internxt webdav enable --host 0.0.0.0 --port 7111 &
      echo "WebDAV-Server-Prozess gestartet. Der Dienst ist jetzt aktiv."
    else
      echo "❌ FEHLER: Der 'internxt login'-Befehl ist fehlgeschlagen, obwohl die Verbindung funktioniert."
      echo "Dies ist ein Bug im internxt-cli Tool."
    fi

  else
    echo "❌ FEHLER: Handshake mit Internxt-Server fehlgeschlagen!"
    echo "HTTP Status Code: ${HTTP_STATUS}"
    echo "Der Internxt-Server blockiert die Anfrage. Dies ist ein serverseitiges Problem bei Internxt."
  fi

else
  echo "❌ FEHLER: PING FEHLGESCHLAGEN. Keine Internetverbindung!"
  echo "Bitte prüfen Sie die Netzwerkeinstellungen des Containers (Bridge-Modus, Firewall)."
fi

echo "--- Diagnose abgeschlossen. Dienst läuft im Analyse-Modus. ---"
# Hält den Container am Leben, damit wir die Logs lesen können
tail -f /dev/null
