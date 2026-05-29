# DevOps Central - On-Demand DevOps Lab

Vollständiges IaC-Grundgerüst für einen kostengünstigen, on-demand DevOps-Stack auf Hetzner Cloud.

## Architektur

- **VPS**: Hetzner Cloud (CPX42: 8 vCPU / 16 GB RAM) mit Docker
- **Reverse Proxy**: Caddy (automatisches HTTPS via Let's Encrypt)
- **GitLab CE**: Docker-Container (Quellcode, CI/CD, Container Registry)
- **Artifactory OSS**: JFrog für Binaries, Docker-Images, Helm-Charts, Maven etc.
- **Kubernetes (optional)**: k3d (leichtgewichtiger k3s) auf dem gleichen VPS

## Voraussetzungen

- Hetzner Cloud Account + API-Token (Write-Berechtigung)
- Eigene Domain mit A-Records für `gitlab.deine-domain.de` und `artifactory.deine-domain.de`
- SSH-Schlüsselpaar

## Schnellstart (5-10 Minuten bis lauffähig)

```bash
# 1. Terraform initialisieren und anwenden
git clone https://github.com/commana/ai-experiments.git
cd ai-experiments/devops-central/terraform

terraform init
terraform apply \
  -var="hcloud_token=dein_hetzner_token" \
  -var="ssh_public_key=$(cat ~/.ssh/id_ed25519.pub)" \
  -var="lab_domain=deine-domain.de"

# 2. DNS konfigurieren (A-Records auf die ausgegebene IP zeigen)

# 3. Auf den VPS einloggen
ssh ubuntu@$(terraform output -raw server_ip)

# 4. Bootstrap ausführen (clont Repo, startet Stack)
cd /opt/devops-central/scripts
chmod +x bootstrap.sh
./bootstrap.sh

# 5. .env anpassen (wichtig: Passwörter & Domain)
nano /opt/devops-central/compose/.env

# 6. Stack neu starten (falls nötig)
cd /opt/devops-central/compose
docker compose down
docker compose up -d
```

**Hinweis**: Der erste Start von GitLab kann 5-10 Minuten dauern (Datenbank-Initialisierung).

## Zugriff

- GitLab: https://gitlab.deine-domain.de (root / Passwort aus .env)
- Artifactory: https://artifactory.deine-domain.de (admin / password)

## Kosten sparen

- VPS nach Gebrauch stoppen oder löschen (`terraform destroy`)
- Vorher Volumes sichern: `docker volume ls` + Backup-Skript
- Typische Kosten bei 8-10 Stunden/Monat: < 5 €

## Backup & Restore

Vor dem Zerstören:
```bash
# Volumes sichern (Beispiel)
docker run --rm -v gitlab_data:/data -v $(pwd):/backup alpine tar czf /backup/gitlab_data.tar.gz -C /data .
# Ähnlich für artifactory_data
```

Oder Hetzner Volume als persistentes Storage mounten (erweiterbar).

## Erweiterungen (nächste Schritte)

- ArgoCD für GitOps auf k3d
- Prometheus + Grafana + Loki Monitoring
- Longhorn Storage für k3d
- GitLab Runner als Kubernetes Executor
- Vault für Secrets

Viel Erfolg beim Experimentieren und Lernen! 🚀
