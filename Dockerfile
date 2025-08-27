# Dockerfile
# Imagem base oficial do n8n
FROM n8nio/n8n:latest

# timezone + utilitários para healthcheck
USER root
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata curl \
  && rm -rf /var/lib/apt/lists/*

ENV TZ=America/Sao_Paulo \
    GENERIC_TIMEZONE=America/Sao_Paulo \
    NODE_ENV=production \
    N8N_USER_FOLDER=/home/node/.n8n

# Garante pastas e permissões
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node

# Healthcheck da API (status ok)
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=5 \
  CMD curl -fsS http://localhost:5678/rest/health | grep -q '"status":"ok"' || exit 1

# Script de entrada decide entre web e worker
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER node
EXPOSE 5678
ENTRYPOINT ["/entrypoint.sh"]
