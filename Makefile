.PHONY: help
help:
	@echo "Commands:"
	@echo "  init          - Initialize Terraform"
	@echo "  plan          - Create a Terraform plan for dev"
	@echo "  apply         - Apply a Terraform plan for dev"
	@echo "  destroy       - Destroy Terraform-managed infrastructure for dev"
	@echo "  plan-prod     - Create a Terraform plan for prod"
	@echo "  apply-prod    - Apply a Terraform plan for prod"
	@echo "  destroy-prod  - Destroy Terraform-managed infrastructure for prod"
	@echo "  fmt           - Format Terraform code"
	@echo "  validate      - Validate Terraform code"
	@echo "  dbt-deps      - Install dbt dependencies"
	@echo "  dbt-run       - Run dbt models"
	@echo "  dbt-test      - Test dbt models"

.PHONY: init
init:
	terraform init

.PHONY: plan
plan:
	terraform plan -var-file=envs/dev/terraform.tfvars

.PHONY: apply
apply:
	terraform apply -var-file=envs/dev/terraform.tfvars -auto-approve

.PHONY: destroy
destroy:
	terraform destroy -var-file=envs/dev/terraform.tfvars -auto-approve

.PHONY: plan-prod
plan-prod:
	terraform plan -var-file=envs/prod/terraform.tfvars

.PHONY: apply-prod
apply-prod:
	terraform apply -var-file=envs/prod/terraform.tfvars -auto-approve

.PHONY: destroy-prod
destroy-prod:
	terraform destroy -var-file=envs/prod/terraform.tfvars -auto-approve

.PHONY: fmt
fmt:
	terraform fmt -recursive

.PHONY: validate
validate:
	terraform validate

.PHONY: dbt-deps
dbt-deps:
	dbt deps

.PHONY: dbt-run
dbt-run:
	dbt run --profiles-dir ./dbt

.PHONY: dbt-test
dbt-test:
	dbt test --profiles-dir ./dbt 