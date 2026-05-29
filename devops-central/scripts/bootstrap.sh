#!/bin/bash
set -e

echo "🚀 DevOps Central - Manuelles Bootstrap / Re-Deploy"

if [ ! -d "/opt/devops-central" ]; then
  sudo git clone https://github.com/commana/ai-experiments.git /opt/devops-central
fi

cd /opt/devops-central/compose

if [ ! -f .env ]; then
  cp .env.example .env
  echo "⚠️  .env wurde erstellt – bitte anpassen: nano .env"
  exit 1
fi

set -a; source .env; set +a

docker compose pull
docker compose up -d

echo "✅ Stack neu gestartet!"
