# Wir starten mit einem offiziellen, Node.js Image
FROM node:18

# Wir setzen ein Arbeitsverzeichnis
WORKDIR /app

# Wir installieren das Internxt CLI-Tool systemweit im Container
RUN npm install -g @internxt/cli

# Wir kopieren unser Start-Skript in den Container
COPY start.sh .

# Wir machen das Skript ausführbar
RUN chmod +x ./start.sh

# Das ist der Befehl, der ausgeführt wird, wenn der Container startet
CMD ["./start.sh"]
