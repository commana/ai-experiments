.PHONY: help init plan apply destroy ssh bootstrap init-backend volume-info

help:
	@echo "DevOps Central - Make Targets"
	@echo "  make init          - terraform init (local state)"
	@echo "  make init-backend  - terraform init with Hetzner Object Storage backend"
	@echo "  make plan          - terraform plan"
	@echo "  make apply         - terraform apply (mit 5GB Cloud Volume)"
	@echo "  make destroy       - terraform destroy (Volume bleibt erhalten!)"
	@echo "  make ssh           - SSH to the server"
	@echo "  make bootstrap     - Stack manuell neu starten"
	@echo "  make volume-info   - Infos zur Cloud Volume anzeigen"

init:
	cd terraform && terraform init

init-backend:
	@echo "==> Initializing with Hetzner Object Storage backend..."
	cd terraform && terraform init -migrate-state

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply

destroy:
	@echo "⚠️  Achtung: Cloud Volume bleibt erhalten!"
	cd terraform && terraform destroy

ssh:
	ssh ubuntu@$$(cd terraform && terraform output -raw server_ip)

bootstrap:
	ssh ubuntu@$$(cd terraform && terraform output -raw server_ip) 'cd /opt/devops-central/scripts && ./bootstrap.sh'

volume-info:
	@echo "Cloud Volume Größe: ${volume_size} GB"
	@echo "Mount Point: /mnt/data"
	@echo "Wichtige Volumes: gitlab_data, artifactory_data"
