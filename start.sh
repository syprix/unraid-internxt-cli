#!/bin/bash

CONFIG_DIR="/root/.config/internxt-cli"

echo "--- Starting Internxt CLI Service ---"

# SCHRITT 1: Das Konfigurationsverzeichnis erstellen (falls es nicht existiert)
# Das ist der entscheidende neue Schritt, der das Initialisierungsproblem löst.
echo "Stelle sicher, dass das Konfigurationsverzeichnis existiert: ${CONFIG_DIR}"
mkdir -p "${CONFIG_DIR}"

# SCHRITT 2: Sicherstellen, dass die Berechtigungen korrekt sind.
chown -R root:root "${CONFIG_DIR}"

# Erst jetzt, wo alles vorbereitet ist, versuchen wir den Login.
echo "Logging into Internxt as ${INTERNXT_EMAIL}..."
internxt login --email "${INTERNXT_EMAIL}" --password "${INTERNXT_PASSWORD}"

echo "Enabling WebDAV server..."
internxt webdav enable --host 0.0.0.0 --port 7111 &

echo "WebDAV server process started."
echo "--- Service is now running ---"

# Hält den Container am Leben
tail -f /dev/null
