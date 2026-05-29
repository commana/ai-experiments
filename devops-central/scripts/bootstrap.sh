#!/bin/bash
set -e

echo "🚀 DevOps Central Bootstrap starting..."

# Ensure we are in the right place
if [ ! -d "/opt/devops-central" ]; then
  echo "Cloning repository..."
  sudo git clone https://github.com/commana/ai-experiments.git /opt/devops-central
fi

cd /opt/devops-central/compose

if [ ! -f .env ]; then
  echo "Creating .env from example..."
  cp .env.example .env
  echo "⚠️  Bitte .env bearbeiten (nano .env) und dann erneut ausführen!"
  exit 1
fi

# Load env
set -a
source .env
set +a

echo "Pulling images..."
docker compose pull

echo "Starting stack..."
docker compose up -d

echo "✅ Stack gestartet!"
echo "GitLab:      https://gitlab.${LAB_DOMAIN}"
echo "Artifactory: https://artifactory.${LAB_DOMAIN}"
echo ""
echo "Warte 2-3 Minuten, dann anmelden (erste GitLab-Start kann länger dauern)."
