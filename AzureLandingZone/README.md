# Azure Landing Zone Terraform Repository

This repository provides a production-grade, reusable Terraform setup for Azure landing zones with multi-region support.

## Architecture

- **Multi-Region**: Primary (East US), DR (West US) using provider aliasing
- **Landing Zone Modules**: Resource Groups, Virtual Networks, Subnets, Virtual Machines, Load Balancers, Application Gateways, Network Security Groups, Firewalls, Identity
- **Security**: NSGs with dynamic rules, Azure Firewall with policies, DDoS protection, Private Endpoints, WAF on AppGW
- **Identity**: Azure AD users, groups, RBAC roles
- **Scalability**: Support for multiple VMs (e.g., 50), for_each for resources
- **Environments**: Dev, Prod with separate tfvars
- **CI/CD**: Azure DevOps pipeline with init, validate, plan, apply, approval gates for prod
- **DevSecOps**: Checkov for SAST, SCA integration
- **State Management**: Azure Storage Account backend with locking
- **Best Practices**: Tagging, naming conventions, locals, outputs for inter-module communication

## Project Structure

```
root/
  modules/
    rg/          # Resource Group module
    vnet/        # Virtual Network module
    subnet/      # Subnet module
    vm/          # Virtual Machine module
    lb/          # Load Balancer module
    appgw/       # Application Gateway module
    nsg/         # Network Security Group module
    firewall/    # Azure Firewall module
    identity/    # Azure AD Identity module
  environments/
    dev/         # Dev environment
    prod/        # Prod environment
  backend/       # Backend configuration
  providers.tf  # Provider configurations
  variables.tf  # Global variables
  outputs.tf    # Global outputs
  azure-pipelines.yml  # CI/CD pipeline
  README.md     # This file
```

## Usage

1. **Prerequisites**:
   - Azure subscription
   - Azure CLI installed and logged in
   - Terraform >= 1.0
   - Azure DevOps project

2. **Setup Backend**:
   - Create a Storage Account for Terraform state
   - Update variables in `variables.tf` or tfvars

3. **Configure Environments**:
   - Update `environments/dev/terraform.tfvars` for dev
   - Update `environments/prod/terraform.tfvars` for prod

4. **Deploy**:
   - For dev: `cd environments/dev && terraform init && terraform plan && terraform apply`
   - For prod: Use Azure DevOps pipeline or manual apply with approval

5. **CI/CD**:
   - Push to main branch to trigger pipeline
   - Dev deploys automatically
   - Prod requires manual approval

## Modules

Each module is reusable with variables. Use for_each or count for scaling.

### Example: VM Module
Supports up to 50 VMs with autoscaling potential.

### Security
- NSGs with dynamic rules
- Azure Firewall with policy-based rules
- DDoS protection toggle
- Private endpoints where applicable

## Best Practices Implemented

- DRY principles
- Modular design
- Tagging strategy (env, owner, cost-center)
- Naming conventions
- Locals for standardization
- Outputs for module communication
- State locking and isolation per environment

## Contributing

Follow the module structure for new components.