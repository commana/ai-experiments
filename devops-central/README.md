# DevOps Central - On-Demand DevOps Lab

**Vollautomatisches IaC-Grundgerüst** – mit einem einzigen `terraform apply` läuft dein kompletter Stack.

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
```

## Terraform State Management (sehr empfohlen)

### Warum Remote State?

- Du arbeitest von mehreren Rechnern
- Du willst später CI/CD einbauen
- Bessere Sicherheit + Versionierung

### Beste Lösung für Hetzner-Nutzer: Hetzner Object Storage

**Vorteile**: Günstig, DSGVO-konform, direkt in deinem Hetzner-Account.

#### Einrichtung (5 Minuten)

1. **Bucket erstellen**
   - Hetzner Cloud Console → Object Storage → "Create Bucket"
   - Name: `devops-central-terraform-state`
   - Location: `fsn1` (oder deine bevorzugte Region)

2. **Access Key erstellen**
   - Im selben Menü "Access Keys" → "Generate Access Key"
   - Key + Secret sicher kopieren

3. **Backend aktivieren**
   ```bash
   cd terraform
   # Datei backend.tf bearbeiten und den S3-Block auskommentieren
   nano backend.tf
   ```

4. **State migrieren**
   ```bash
   terraform init -migrate-state
   ```

Fertig! Dein State liegt jetzt sicher in Hetzner Object Storage.

> **Hinweis**: Hetzner Object Storage bietet kein automatisches State Locking. Für echte Team- oder CI/CD-Nutzung empfehlen wir Terraform Cloud (kostenlos bis 500 Ressourcen).

## Zugriff nach dem Apply

- **GitLab**: https://gitlab.deine-domain.de
- **Artifactory**: https://artifactory.deine-domain.de

## Nächste Schritte

- k3d Cluster hinzufügen
- ArgoCD + GitOps
- Monitoring (Prometheus + Grafana)

Viel Erfolg! 🚀