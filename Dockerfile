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

# Install the stable version of the CLI tool AND the PM2 process manager.
RUN npm install -g @internxt/cli@~1.5.6 pm2

# Set the working directory.
WORKDIR /app

# Copy the start script.
COPY start.sh .

# Make the script executable.
RUN chmod +x ./start.sh

# Define the default command to run when the container starts.
CMD ["./start.sh"]
