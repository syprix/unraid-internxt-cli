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
  
  # Extract the subject name from the SSL certificate.
  CERT_SUBJECT=$(openssl s_client -connect ${API_HOST}:443 -servername ${API_HOST} 2>/dev/null <<< "Q" | openssl x509 -noout -subject)

  # Check if the certificate's Common Name (CN) matches the expected host.
  if [[ "${CERT_SUBJECT}" == *"CN = ${API_HOST}"* ]]; then
    echo "✅ CERTIFICATE VALID. Connected to the authentic Internxt server."
    
    # --- 3. Attempt Automatic Login ---
    echo "Ensuring config directory exists: ${CONFIG_DIR}"
    mkdir -p "${CONFIG_DIR}"
    chown -R root:root "${CONFIG_DIR}"
    
    echo "Attempting automatic login..."
    internxt login --email "${INTERNXT_EMAIL}" --password "${INTERNXT_PASSWORD}"

    # Check if the login command was successful.
    if [ $? -eq 0 ]; then
      echo "✅ LOGIN SUCCESSFUL. Starting WebDAV server..."
      internxt webdav enable --host 0.0.0.0 --port 7111 &
      echo "WebDAV server process started. Service is now active."
    else
      echo "❌ ERROR: The 'internxt login' command failed, despite a valid connection to the correct server."
      echo "This indicates a bug within the internxt-cli tool itself."
    fi

  else
    echo "❌ ERROR: INVALID CERTIFICATE!"
    echo "The server at ${API_HOST} did not provide a valid certificate."
    echo "Received certificate subject: ${CERT_SUBJECT}"
  fi

else
  echo "❌ ERROR: PING FAILED. No internet connection!"
  echo "Please check the container's network settings."
fi

echo "--- Diagnosis complete. Service is running in analysis mode. ---"
# Keep the container running to allow log inspection.
tail -f /dev/null
