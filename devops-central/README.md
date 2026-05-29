# DevOps Central - On-Demand DevOps Lab

**Vollautomatisches IaC-Grundgerüst** mit persistenter **Cloud Volume** (5 GB).

## Was passiert beim `terraform apply`?

1. VPS + 5 GB Cloud Volume wird erstellt
2. Volume wird automatisch formatiert + gemountet unter `/mnt/data`
3. GitLab- und Artifactory-Daten werden auf der Cloud Volume gespeichert
4. Stack startet automatisch

**Daten bleiben erhalten**, auch wenn du den VPS zerstörst und neu aufbaust!

## Schnellstart

```bash
git clone https://github.com/commana/ai-experiments.git
cd ai-experiments/devops-central/terraform

make init
make apply
```

## Wichtiger Hinweis zur 5 GB Volume

**5 GB ist sehr klein!** GitLab + Artifactory können schnell mehr Platz brauchen (Repositories, Docker Images, Logs).

**Empfehlung**: Später auf 20–50 GB erhöhen (einfach `volume_size` in `variables.tf` ändern und `terraform apply`).

## Makefile Targets

```bash
make help
make init
make init-backend     # Remote State
make apply
make ssh
make bootstrap
make destroy
```

## Zugriff

- GitLab: https://gitlab.deine-domain.de
- Artifactory: https://artifactory.deine-domain.de

Viel Erfolg! 🚀