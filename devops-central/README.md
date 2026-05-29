# DevOps Central - On-Demand DevOps Lab

**Vollautomatisches IaC-Grundgerüst** – mit einem einzigen `terraform apply` läuft dein kompletter Stack.

## Schnellstart (ein Befehl)

```bash
git clone https://github.com/commana/ai-experiments.git
cd ai-experiments/devops-central/terraform

make init
make apply
```

## Makefile Targets (sehr praktisch)

```bash
make help           # Zeigt alle verfügbaren Targets
make init           # Lokaler State
make init-backend   # Mit Hetzner Object Storage Backend
make apply          # Vollautomatisches Setup
make ssh            # Direkt auf den Server
make bootstrap      # Stack manuell neu starten
make destroy        # Alles löschen
```

## Terraform State Management

### Hetzner Object Storage (empfohlen)

1. Bucket + Access Keys in Hetzner Console anlegen
2. `backend.tf` anpassen (S3-Block aktivieren)
3. `make init-backend` ausführen

Fertig! Dein State liegt jetzt sicher in Hetzner Object Storage.

> **Hinweis**: Hetzner bietet kein State Locking. Für Team/CI-CD empfehlen wir Terraform Cloud.

## Zugriff

- GitLab: https://gitlab.deine-domain.de
- Artifactory: https://artifactory.deine-domain.de

Viel Erfolg! 🚀