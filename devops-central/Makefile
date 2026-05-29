.PHONY: help init plan apply destroy ssh bootstrap init-backend

help:
	@echo "DevOps Central - Make Targets"
	@echo "  make init          - terraform init (local state)"
	@echo "  make init-backend  - terraform init with Hetzner Object Storage backend"
	@echo "  make plan          - terraform plan"
	@echo "  make apply         - terraform apply (automatisches Setup)"
	@echo "  make destroy       - terraform destroy"
	@echo "  make ssh           - SSH to the server"
	@echo "  make bootstrap     - Run bootstrap script on server"

init:
	cd terraform && terraform init

init-backend:
	@echo "==> Initializing with Hetzner Object Storage backend..."
	@echo "    Stelle sicher, dass der S3-Block in backend.tf auskommentiert ist!"
	cd terraform && terraform init -migrate-state

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply

destroy:
	cd terraform && terraform destroy

ssh:
	ssh ubuntu@$$(cd terraform && terraform output -raw server_ip)

bootstrap:
	ssh ubuntu@$$(cd terraform && terraform output -raw server_ip) 'cd /opt/devops-central/scripts && ./bootstrap.sh'
