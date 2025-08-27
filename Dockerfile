
FROM n8nio/n8n:latest

USER root
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata curl \
  && rm -rf /var/lib/apt/lists/*

ENV TZ=America/Sao_Paulo \
    GENERIC_TIMEZONE=America/Sao_Paulo \
    NODE_ENV=production \
    N8N_USER_FOLDER=/home/node/.n8n

RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node


HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=5 \
  CMD curl -fsS http://localhost:5678/rest/health | grep -q '"status":"ok"' || exit 1

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER node
EXPOSE 5678
ENTRYPOINT ["/entrypoint.sh"]
