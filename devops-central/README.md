# DevOps Central - On-Demand DevOps Lab

**Vollautomatisches IaC-Grundgerüst** mit persistenter **Cloud Volume** (aktuell 5 GB).

## Wichtiger Hinweis zur Volume-Größe

**Die Größe der Cloud Volume kann nicht einfach per `terraform apply` erhöht werden!**

Terraform zerstört und erstellt die Volume neu, wenn du `volume_size` änderst → **Datenverlust**.

### Korrekte Möglichkeiten später zu vergrößern:

**1. Schnellste Variante (empfohlen für kleine Erhöhungen)**

1. In der Hetzner Cloud Console die Volume auf z. B. 20 oder 50 GB vergrößern
2. Auf dem Server ausführen:
   ```bash
   ssh ubuntu@<IP>
   sudo resize2fs /dev/disk/by-id/scsi-0HC_Volume_devops-data
   ```

**2. Saubere Variante (bei großen Sprüngen)**

- Neue größere Volume anlegen
- Daten mit `rsync` oder `tar` migrieren
- Alte Volume löschen
- Terraform-State anpassen

**Empfehlung**: Starte lieber gleich mit 20–50 GB, wenn du Repositories, Docker Images oder CI-Artefakte speichern willst.

## Was passiert beim `terraform apply`?

1. VPS + Cloud Volume wird erstellt
2. Volume wird automatisch gemountet unter `/mnt/data`
3. GitLab- und Artifactory-Daten landen auf der Volume
4. Stack startet automatisch

**Daten bleiben erhalten**, auch wenn du den VPS zerstörst!

## Schnellstart

```bash
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

Viel Erfolg! 🚀