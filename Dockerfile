# Base image: Use a full Debian OS for maximum compatibility.
FROM debian:bullseye

# Install essential dependencies for building, networking, and diagnostics.
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    iputils-ping \
    openssl \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js v18, which is required by the CLI.
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Install a specific, known-stable version range of the Internxt CLI and the PM2 process manager.
RUN npm install -g @internxt/cli@~1.5.6 pm2

# Set the working directory inside the container.
WORKDIR /app

# Copy the start script into the working directory.
COPY start.sh .

# Make the start script executable.
RUN chmod +x ./start.sh

# Define the default command to run when the container starts.
CMD ["./start.sh"]
