# Wir starten mit einem vollwertigen Debian-Betriebssystem
FROM debian:bullseye

# Wir installieren grundlegende Werkzeuge, git und curl
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Wir installieren Node.js v18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Jetzt installieren wir das Internxt CLI-Tool
RUN npm install -g @internxt/cli

# Wir setzen unser Arbeitsverzeichnis
WORKDIR /app

# Wir kopieren unser Start-Skript hinein
COPY start.sh .

# Wir machen das Skript ausführbar
RUN chmod +x ./start.sh

# Das ist der Befehl, der beim Start ausgeführt wird
CMD ["./start.sh"]

# Force clean build
