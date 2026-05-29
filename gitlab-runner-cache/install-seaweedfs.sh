#!/bin/bash
# deploy-seaweedfs.sh
# Deployt/Updatet SeaweedFS + setzt automatisch die 30-Tage-Lifecycle-Policy
# Aufruf: ./deploy-seaweedfs.sh <NAMESPACE>

set -euo pipefail

# ================== KONFIGURATION ==================
if [ $# -eq 0 ]; then
  echo "❌ Fehler: Namespace fehlt!"
  echo "Aufruf: $0 <NAMESPACE>"
  echo "Beispiel: $0 mein-runner-ns"
  exit 1
fi

NAMESPACE="$1"
RELEASE_NAME="seaweedfs-cache"
# =================================================

echo "=== SeaweedFS + 30-Tage Cache Lifecycle Deployment ==="
echo "Namespace     : $NAMESPACE"
echo "Release Name  : $RELEASE_NAME"
echo ""

# 1. Helm Upgrade / Install (mit eingebauter Wartezeit)
echo "→ 1. Helm Upgrade durchführen..."

helm repo add seaweedfs https://seaweedfs.github.io/seaweedfs/helm --force-update
helm repo update

helm upgrade --install "$RELEASE_NAME" seaweedfs/seaweedfs \
  --namespace "$NAMESPACE" \
  --values values-seaweedfs.yaml \
  --wait --timeout 10m

echo "✅ Helm Deployment abgeschlossen."

# 2. Explizit auf alle SeaweedFS-Pods warten (zusätzliche Sicherheit)
echo "→ 2. Warte bis alle SeaweedFS Pods (master/volume/filer) Ready sind (max. 5 Minuten)..."
oc wait --for=condition=Ready pod \
  -l "app.kubernetes.io/instance=$RELEASE_NAME" \
  -n "$NAMESPACE" \
  --timeout=300s \
  --all

echo "✅ Alle SeaweedFS Pods sind Ready."

# 3. Lifecycle-Job mit envsubst rendern und anwenden
echo "→ 3. 30-Tage-Lifecycle-Policy setzen (mit envsubst)..."
# Template rendern und direkt anwenden
envsubst < seaweedfs-lifecycle-job.yaml | oc apply -f - -n "$NAMESPACE"

echo ""
echo "🎉 Erfolg! SeaweedFS ist deployed und die 30-Tage-Cleanup-Policy ist aktiv."
echo ""
echo "Nächster Schritt: Runner-CR mit S3-Cache konfigurieren."