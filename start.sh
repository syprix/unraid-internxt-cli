#!/bin/bash

CONFIG_FILE="/root/.config/internxt-cli/config.json"

echo "--- Starting Internxt CLI Service ---"

# Prüfen, ob die Konfigurationsdatei existiert UND ein Login-Token enthält
if [ -f "$CONFIG_FILE" ] && grep -q "authToken" "$CONFIG_FILE"; then
  echo "Konfigurationsdatei gefunden. Login-Token erkannt."
  echo "Starte WebDAV-Server..."
  internxt webdav enable --host 0.0.0.0 --port 7111 &
  echo "WebDAV-Server-Prozess gestartet."
  echo "--- Dienst läuft jetzt ---"
else
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "!! ACHTUNG: KEINE ANMELDUNG GEFUNDEN                       !!"
  echo "!! Bitte loggen Sie sich manuell über die Konsole ein:    !!"
  echo "!! > internxt login                                       !!"
  echo "!! Danach den Container neu starten.                      !!"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
fi

# Dieser Befehl hält den Container am Leben
tail -f /dev/null
