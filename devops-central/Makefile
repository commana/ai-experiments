.PHONY: help init plan apply destroy ssh bootstrap

help:
	@echo "DevOps Central - Make Targets"
	@echo "  make init     - terraform init"
	@echo "  make plan     - terraform plan"
	@echo "  make apply    - terraform apply"
	@echo "  make destroy  - terraform destroy"
	@echo "  make ssh      - SSH to the server"
	@echo "  make bootstrap- Run bootstrap on server (after SSH)"

init:
	cd terraform && terraform init

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
