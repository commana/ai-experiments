# DevOps Central - On-Demand DevOps Lab

**Vollautomatisches IaC-Grundgerüst** mit persistenter **20 GB Cloud Volume**.

## Cloud Volume – Wichtige Hinweise

Deine Daten (GitLab + Artifactory) liegen auf einer separaten 20 GB Hetzner Cloud Volume. Das hat zwei große Vorteile:

- Die Daten überleben `terraform destroy`
- Du kannst die Volume später einfach vergrößern

### Später vergrößern (wenn 20 GB nicht mehr reichen)

**So gehst du vor (ohne Datenverlust):**

1. Gehe in die [Hetzner Cloud Console](https://console.hetzner.cloud/)
2. **Volumes** → `devops-data` auswählen
3. Auf **"Resize"** klicken und z. B. auf 50 GB oder 100 GB erhöhen
4. Auf dem Server ausführen:
   ```bash
   ssh ubuntu@<IP>
   sudo resize2fs /dev/disk/by-id/scsi-0HC_Volume_devops-data
   ```
5. Fertig – die Volume ist sofort größer

> **Wichtig**: Terraform kann die Größe **nicht** automatisch erhöhen (würde die Volume zerstören). Deshalb immer über die Hetzner Console + `resize2fs`.

## Was passiert beim `terraform apply`?

1. VPS + 20 GB Cloud Volume wird erstellt
2. Volume wird automatisch unter `/mnt/data` gemountet
3. GitLab- und Artifactory-Daten landen auf der Volume
4. Der komplette Stack startet automatisch

## Schnellstart

```bash
git clone https://github.com/commana/ai-experiments.git
cd ai-experiments/devops-central/terraform

make apply
```

## Makefile Targets

```bash
make help
make apply
make ssh
make bootstrap
make destroy          # Volume bleibt erhalten!
make volume-info
```

## Zugriff

- GitLab: https://gitlab.deine-domain.de
- Artifactory: https://artifactory.deine-domain.de

Viel Erfolg! 🚀