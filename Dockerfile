# Base image: Use a full Debian OS for maximum compatibility.
FROM debian:bullseye

# Install essential dependencies, including the 'expect' tool for automation.
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    iputils-ping \
    openssl \
    net-tools \
    expect \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js v18.
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Install a specific, known-stable version range of the Internxt CLI.
RUN npm install -g @internxt/cli@~1.5.6

# Set the working directory.
WORKDIR /app

# Copy both the main start script and the new automation script.
COPY start.sh .
COPY login.exp .

# Make both scripts executable.
RUN chmod +x ./start.sh
RUN chmod +x ./login.exp

# Define the default command to run when the container starts.
CMD ["./start.sh"]
