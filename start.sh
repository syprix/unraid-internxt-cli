#!/bin/bash

# --- KONFIGURATION ---
CONFIG_DIR="/root/.config/internxt-cli"
PING_TARGET="8.8.8.8"
API_HOST="api.internxt.com"

echo "--- Starting Internxt CLI Service ---"

# --- SCHRITT 1: PING-TEST (Internetverbindung allgemein) ---
echo "Teste Internetverbindung durch Ping an ${PING_TARGET}..."
if ping -c 4 -W 10 "${PING_TARGET}"; then
  echo "✅ PING ERFOLGREICH. Container hat Internetzugang."

  # --- SCHRITT 2: "AUSWEIS"-TEST (Identität des Servers prüfen) ---
  echo "Überprüfe den 'Ausweis' von ${API_HOST}..."

  # Wir holen uns den Namen aus dem SSL-Zertifikat
  CERT_SUBJECT=$(openssl s_client -connect ${API_HOST}:443 -servername ${API_HOST} 2>/dev/null <<< "Q" | openssl x509 -noout -subject)

  # Wir prüfen, ob im Ausweis der richtige Name steht
  if [[ "${CERT_SUBJECT}" == *"CN = ${API_HOST}"* ]]; then
    echo "✅ AUSWEIS KORREKT. Wir sprechen mit dem echten Internxt-Server."

    # --- SCHRITT 3: LOGIN-VERSUCH (Nur bei Erfolg) ---
    echo "Stelle sicher, dass das Konfigurationsverzeichnis existiert: ${CONFIG_DIR}"
    mkdir -p "${CONFIG_DIR}"
    chown -R root:root "${CONFIG_DIR}"

    echo "Versuche jetzt den automatischen Login..."
    internxt login --email "${INTERNXT_EMAIL}" --password "${INTERNXT_PASSWORD}"

    if [ $? -eq 0 ]; then
      echo "✅ LOGIN ERFOLGREICH. Starte WebDAV-Server..."
      internxt webdav enable --host 0.0.0.0 --port 7111 &
      echo "WebDAV-Server-Prozess gestartet. Der Dienst ist jetzt aktiv."
    else
      echo "❌ FEHLER: Der 'internxt login'-Befehl ist fehlgeschlagen, obwohl die Verbindung zum korrekten Server besteht."
      echo "Dies ist ein Bug im internxt-cli Tool."
    fi

  else
    echo "❌ FEHLER: FALSCHER AUSWEIS!"
    echo "Der Server, mit dem wir sprechen, ist NICHT der echte Internxt-Server."
    echo "Empfangener Ausweis: ${CERT_SUBJECT}"
  fi

else
  echo "❌ FEHLER: PING FEHLGESCHLAGEN. Keine Internetverbindung!"
  echo "Bitte prüfen Sie die Netzwerkeinstellungen des Containers."
fi

echo "--- Diagnose abgeschlossen. Dienst läuft im Analyse-Modus. ---"
tail -f /dev/null
