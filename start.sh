#!/bin/bash

# --- Configuration ---
CONFIG_DIR="/root/.config/internxt-cli"
PING_TARGET="8.8.8.8"
API_HOST="api.internxt.com"

echo "--- Starting Internxt CLI Service ---"

# --- 1. General Internet Connection Test (Ping) ---
echo "Testing internet connection by pinging ${PING_TARGET}..."
if ping -c 4 -W 10 "${PING_TARGET}"; then
  echo "✅ PING SUCCESSFUL. Container has internet access."

  # --- 2. Server Identity Verification (SSL Certificate Check) ---
  echo "Verifying identity of ${API_HOST}..."
  CERT_SUBJECT=$(openssl s_client -connect ${API_HOST}:443 -servername ${API_HOST} 2>/dev/null <<< "Q" | openssl x509 -noout -subject)

  if [[ "${CERT_SUBJECT}" == *"CN = ${API_HOST}"* ]]; then
    echo "✅ CERTIFICATE VALID. Connected to the authentic Internxt server."
    
    # --- 3. Attempt Automatic Login ---
    echo "Ensuring config directory exists: ${CONFIG_DIR}"
    mkdir -p "${CONFIG_DIR}"
    chown -R root:root "${CONFIG_DIR}"
    
    echo "Attempting automatic login..."
    internxt login --email "${INTERNXT_EMAIL}" --password "${INTERNXT_PASSWORD}"

    if [ $? -eq 0 ]; then
      echo "✅ LOGIN SUCCESSFUL."
      
      # --- 4. Configure and Start WebDAV server with PM2 Supervisor ---
      echo "Configuring WebDAV server to listen on 0.0.0.0:7111..."
      internxt webdav config --host 0.0.0.0 --port 7111

      echo "Starting WebDAV server with PM2 Supervisor to ensure stability..."
      INTERNXT_EXEC_PATH=$(which internxt)
      
      # This command starts the WebDAV service via PM2 and keeps the container running.
      pm2-runtime start ${INTERNXT_EXEC_PATH} --name "internxt-webdav" -- \
        webdav enable

    else
      echo "❌ ERROR: The 'internxt login' command failed."
    fi
  else
    echo "❌ ERROR: INVALID CERTIFICATE! Could not verify server identity."
  fi
else
  echo "❌ ERROR: PING FAILED. No internet connection!"
fi

# This part will only be reached if the pm2-runtime command fails or if any previous check fails.
echo "--- Script finished. Check logs for status. ---"
tail -f /dev/null
