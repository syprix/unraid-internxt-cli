#!/bin/bash

# --- Configuration ---
# The config directory is controlled by XDG_CONFIG_HOME env var set in Dockerfile.
CONFIG_DIR="${XDG_CONFIG_HOME:-/config}"
CONFIG_SUBDIR="${CONFIG_DIR}/internxt" # The actual subdir used by the tool
CONFIG_FILE="${CONFIG_SUBDIR}/config.json"
# Use port 9192 by default if variable is somehow unset
WEB_PORT=${INTERNXT_WEB_PORT:-9192}
AUTH_TOKEN=${INTERNXT_AUTH_TOKEN} # Read token from environment

echo "--- Starting Internxt CLI Service using Auth Token ---"

# --- 1. Check if Auth Token is provided ---
if [ -z "$AUTH_TOKEN" ]; then
  echo "❌ ERROR: INTERNXT_AUTH_TOKEN is not set. Please provide your token during container setup."
  sleep 60
  exit 1
fi

# --- 2. Create the config directory and file manually from Token ---
echo "Ensuring config directory exists: ${CONFIG_SUBDIR}"
mkdir -p "${CONFIG_SUBDIR}"
chown -R root:root "${CONFIG_DIR}" # Set ownership on the base mapped dir

echo "Creating/Overwriting config file with provided Auth Token..."
# Create the JSON structure expected by the CLI
echo "{\"authToken\": \"${AUTH_TOKEN}\"}" > "$CONFIG_FILE"
chown root:root "$CONFIG_FILE"
echo "✅ Config file created/updated successfully."

# --- 3. Start WebDAV Server directly ---
# No separate config step needed if config file exists.
echo "Starting WebDAV server directly on internal port ${WEB_PORT}..."
# Use exec to run the server in the foreground.
# Specify the config file path explicitly to be safe.
exec /usr/lib/node_modules/@internxt/cli/bin/run --config "$CONFIG_FILE" webdav enable --host 0.0.0.0 --port ${WEB_PORT}

# Fallback in case 'exec' fails
echo "--- Script finished unexpectedly. ---"
tail -f /dev/null
