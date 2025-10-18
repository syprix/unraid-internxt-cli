# Base image: Use a full Debian OS for maximum compatibility.
FROM debian:bullseye

# Install essential dependencies.
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    iputils-ping \
    openssl \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js v18.
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Install a specific, known-stable version range of the Internxt CLI.
RUN npm install -g @internxt/cli@~1.5.6

# Set the standard config directory environment variable PERMANENTLY.
ENV XDG_CONFIG_HOME=/config

# Set the working directory.
WORKDIR /app

# Copy the start script.
COPY start.sh .

# Make the start script executable.
RUN chmod +x ./start.sh

# Define the default command to run when the container starts.
CMD ["./start.sh"]

# Optional Health Check (uses the default port 9192)
HEALTHCHECK --interval=1m --timeout=10s --start-period=30s --retries=3 \
  CMD curl --fail http://localhost:9192 || exit 1
