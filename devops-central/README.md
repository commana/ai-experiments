# DevOps Central - On-Demand DevOps Lab

**Vollautomatisches IaC-Grundgerüst** – mit einem einzigen `terraform apply` läuft dein kompletter Stack (GitLab + Artifactory + Caddy).

## Was passiert beim `terraform apply`?

1. VPS wird auf Hetzner erstellt (Ubuntu 24.04 + Docker + Firewall)
2. Repo wird automatisch geklont
3. `.env` wird mit deinen Variablen befüllt
4. Docker Compose Stack startet automatisch (GitLab + Artifactory hinter Caddy mit Let's Encrypt)

**Fertig in ca. 8-12 Minuten** (inkl. GitLab-First-Start).

## Schnellstart (ein Befehl)

```bash
git clone https://github.com/commana/ai-experiments.git
cd ai-experiments/devops-central/terraform

terraform init

terraform apply \
  -var="hcloud_token=dein_hetzner_token" \
  -var="ssh_public_key=$(cat ~/.ssh/id_ed25519.pub)" \
  -var="lab_domain=deine-domain.de" \
  -var="admin_email=admin@deine-domain.de" \
  -var="gitlab_root_password=SuperSicheresPasswort123!"

# Danach nur noch DNS konfigurieren (A-Records auf die IP)
```

## Zugriff nach dem Apply

- **GitLab**: https://gitlab.deine-domain.de (User: root / Passwort aus Variable)
- **Artifactory**: https://artifactory.deine-domain.de (User: admin / Passwort: password – beim ersten Login ändern!)

## Manuelle Nachjustierung

Falls du später etwas ändern willst:

```bash
ssh ubuntu@<IP>
cd /opt/devops-central/compose
nano .env
docker compose up -d
```

Oder das `bootstrap.sh` manuell ausführen (z.B. nach `terraform destroy` + neuem Apply).

## Kosten & Backup

- Bei stundenweiser Nutzung oft < 5 €/Monat
- Vor `terraform destroy`: Volumes sichern (siehe README im Repo)

## Nächste Schritte

- k3d Cluster hinzufügen (`k3d cluster create devops-lab`)
- ArgoCD + GitOps
- Monitoring Stack

Viel Spaß! 🚀