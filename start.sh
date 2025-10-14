#!/bin/bash

echo "--- Starting Internxt CLI Service ---"

if [ -z "${INTERNXT_EMAIL}" ]; then
  echo "FEHLER: Die Umgebungsvariable INTERNXT_EMAIL ist nicht gesetzt."
  exit 1
fi

if [ -z "${INTERNXT_PASSWORD}" ]; then
  echo "FEHLER: Die Umgebungsvariable INTERNXT_PASSWORD ist nicht gesetzt."
  exit 1
fi

echo "Logging into Internxt as ${INTERNXT_EMAIL}..."
internxt login --email "${INTERNXT_EMAIL}" --password "${INTERNXT_PASSWORD}"

echo "Login successful. Enabling WebDAV server..."
internxt webdav enable --host 0.0.0.0 --port 7111 &

echo "WebDAV server process started."
echo "--- Service is now running ---"

tail -f /dev/null
