#!/bin-bash

echo "--- Starting Internxt CLI Service ---"

# Überprüfen, ob die E-Mail-Variable gesetzt ist
if [ -z "${INTERNXT_EMAIL}" ]; then
  echo "FEHLER: Die Umgebungsvariable INTERNXT_EMAIL ist nicht gesetzt."
  exit 1
fi

# Überprüfen, ob die Passwort-Variable gesetzt ist
if [ -z "${INTERNXT_PASSWORD}" ]; then
  echo "FEHLER: Die Umgebungsvariable INTERNXT_PASSWORD ist nicht gesetzt."
  exit 1
fi

echo "Logging into Internxt as ${INTERNXT_EMAIL}..."

# Der automatische Login-Versuch
# Das Passwort wird in Anführungszeichen übergeben, um Sonderzeichen zu schützen
internxt login --email "${INTERNXT_EMAIL}" --password "${INTERNXT_PASSWORD}"

echo "Enabling WebDAV server..."

# Der WebDAV-Server wird gestartet
internxt webdav enable --host 0.0.0.0 --port 7111 &

echo "WebDAV server process started."
echo "--- Service is now running ---"

# Dieser Befehl hält den Container am Leben
tail -f /dev/null
