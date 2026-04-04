# Makefile - Convenient Terraform commands

# Variables
TF := terraform
ENVIRONMENT ?= dev
TF_VARS := -var-file=environments/$(ENVIRONMENT)/$(ENVIRONMENT).tfvars
TF_BACKEND := -backend-config=environments/$(ENVIRONMENT)/backend.tfbackend

.PHONY: help init validate fmt plan apply destroy output clean

help:
	@echo "Terraform Infrastructure - Available Commands"
	@echo ""
	@echo "make init      ENVIRONMENT=dev      Initialize Terraform"
	@echo "make validate                        Validate Terraform configuration"
	@echo "make fmt                             Format Terraform files"
	@echo "make plan      ENVIRONMENT=dev      Show what will be created"
	@echo "make apply     ENVIRONMENT=dev      Deploy infrastructure"
	@echo "make destroy   ENVIRONMENT=dev      Destroy infrastructure (careful!)"
	@echo "make output    ENVIRONMENT=dev      Show deployment outputs"
	@echo "make state-list                      List resources in state"
	@echo "make state-show RESOURCE=azurerm_resource_group.main  Show resource details"
	@echo "make clean                           Remove local state files"
	@echo ""
	@echo "Examples:"
	@echo "  make plan ENVIRONMENT=dev"
	@echo "  make apply ENVIRONMENT=staging"
	@echo "  make destroy ENVIRONMENT=dev"

init:
	@echo "Initializing Terraform..."
	$(TF) init $(TF_BACKEND) -upgrade

validate:
	@echo "Validating Terraform configuration..."
	$(TF) validate

fmt:
	@echo "Formatting Terraform files..."
	$(TF) fmt -recursive

fmt-check:
	@echo "Checking Terraform format..."
	$(TF) fmt -check -recursive

plan:
	@echo "Planning Terraform deployment for $(ENVIRONMENT)..."
	$(TF) plan $(TF_VARS) -out=tfplan-$(ENVIRONMENT)
	@echo ""
	@echo "Plan saved to tfplan-$(ENVIRONMENT)"
	@echo "Review plan, then run: make apply ENVIRONMENT=$(ENVIRONMENT)"

apply:
	@echo "Applying Terraform configuration for $(ENVIRONMENT)..."
	$(TF) apply $(TF_VARS) -auto-approve
	@echo ""
	@echo "Deployment complete! Run 'make output' to see results."

destroy:
	@echo "WARNING: This will destroy all $(ENVIRONMENT) infrastructure!"
	@echo "Type 'yes' to confirm..."
	$(TF) destroy $(TF_VARS)

output:
	@echo "Terraform outputs for $(ENVIRONMENT):"
	$(TF) output

ssh-key:
	@echo "Generating SSH key pair..."
	@mkdir -p ssh
	@ssh-keygen -t rsa -b 4096 -f ssh/id_rsa -N "" || echo "SSH key already exists"
	@echo "SSH key created at ssh/id_rsa.pub"

state-list:
	@echo "Resources in state:"
	$(TF) state list

state-show:
	@ifndef RESOURCE
	@echo "Usage: make state-show RESOURCE=azurerm_resource_group.main"
	@else
	$(TF) state show $(RESOURCE)
	@endif

state-pull:
	@echo "Pulling current state..."
	$(TF) state pull > current-state-backup.json

state-push:
	@echo "WARNING: Pushing state file can be destructive!"
	@echo "Only do this if you know what you're doing."
	@read -p "Continue? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		$(TF) state push state.json; \
	fi

clean:
	@echo "Cleaning up local Terraform files..."
	@rm -rf .terraform/
	@rm -f .terraform.lock.hcl
	@rm -f *.tfstate
	@rm -f *.tfstate.*
	@rm -f tfplan-*
	@echo "Cleaned!"

lint:
	@echo "Running linting checks..."
	@which tflint > /dev/null || (echo "tflint not installed. Install with: brew install tflint"; exit 1)
	@tflint

docs:
	@echo "Generating documentation..."
	@which terraform-docs > /dev/null || (echo "terraform-docs not installed. Install with: brew install terraform-docs"; exit 1)
	@terraform-docs markdown table --output-file modules/network/README.md modules/network
	@terraform-docs markdown table --output-file modules/compute/README.md modules/compute
	@terraform-docs markdown table --output-file modules/storage/README.md modules/storage
	@terraform-docs markdown table --output-file modules/security/README.md modules/security

.DEFAULT_GOAL := help
