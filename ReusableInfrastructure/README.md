# Reusable Terraform Infrastructure Repository

A **plug-and-play, enterprise-grade Terraform framework** designed for deploying consistent Azure infrastructure across multiple projects, teams, regions, and environments with **zero hardcoding**.

## 🎯 Key Features

✅ **100% Reusable** - Clone and deploy for any new project with minimal changes  
✅ **Configuration-Driven** - No code modifications needed, only update tfvars  
✅ **Multi-Environment** - Dev, Staging, Prod with different configurations  
✅ **Multi-Region** - Support for multiple Azure regions  
✅ **Multi-Project** - Handle multiple projects with dynamic naming  
✅ **Feature Toggles** - Enable/disable resources on demand  
✅ **Enterprise Security** - Built-in compliance, tagging, managed identities  
✅ **CI/CD Ready** - GitHub Actions workflows included  
✅ **DRY Principle** - No code duplication, fully modular  
✅ **Production-Grade** - High availability, disaster recovery, monitoring  

---

## 📁 Repository Structure

```
ReusableInfrastructure/
├── modules/                          # Reusable Terraform modules
│   ├── network/                      # Virtual networks, subnets, NSGs
│   ├── compute/                      # Virtual machines
│   ├── storage/                      # Storage accounts, blob, file shares
│   └── security/                     # Key Vault, managed identities
├── environments/                     # Environment-specific configs
│   ├── dev/
│   │   ├── dev.tfvars               # Dev environment variables
│   │   └── backend.tfbackend        # Dev backend config
│   ├── staging/
│   │   ├── staging.tfvars
│   │   └── backend.tfbackend
│   └── prod/
│       ├── prod.tfvars
│       └── backend.tfbackend
├── templates/                        # Advanced templates (optional)
├── .github/workflows/               # CI/CD pipelines
│   ├── terraform-validate.yml
│   ├── terraform-plan.yml
│   └── terraform-apply.yml
├── main.tf                          # Module orchestration
├── variables.tf                     # Core variables & configuration schema
├── outputs.tf                       # Output definitions
├── locals.tf                        # Local naming conventions
├── versions.tf                      # Terraform & provider versions
├── provider.tf                      # Azure provider config
├── terraform.tfstate               # Local state (can use remote backend)
└── README.md
```

---

## 🚀 Quick Start (5 Minutes)

### Step 1: Clone Repository
```bash
git clone <repo-url> my-infrastructure
cd my-infrastructure
```

### Step 2: Update Configuration
Edit `environments/dev/dev.tfvars`:

```hcl
# Change only these 5 values:
azure_subscription_id = "YOUR_SUBSCRIPTION_ID"
project_name          = "myapp"           # Your project name
environment           = "dev"
primary_region        = "eastus"
owner                 = "team@company.com"
cost_center           = "PROJ-001"
```

### Step 3: Initialize Terraform
```bash
terraform init
# Or with specific backend:
# terraform init -backend-config=environments/dev/backend.tfbackend
```

### Step 4: Plan Deployment
```bash
terraform plan -var-file=environments/dev/dev.tfvars
```

### Step 5: Apply Configuration
```bash
terraform apply -var-file=environments/dev/dev.tfvars
```

**That's it!** Your infrastructure is deployed. 🎉

---

## 🔧 Configuration Framework

### Infrastructure Configuration Object

The `infrastructure_config` variable is the **single source of truth** for all infrastructure decisions:

```hcl
infrastructure_config = {
  dev = {
    # Networking
    enable_network       = true        # Deploy VNet?
    vpc_cidr             = "10.0.0.0/16"
    enable_nat_gateway   = false
    enable_bastion       = false
    enable_ddos_standard = false

    # Compute
    enable_vm             = true
    vm_count              = 1
    vm_size               = "Standard_B2s"
    vm_os_disk_type       = "Standard_LRS"
    # ... more compute options

    # Storage
    enable_storage        = true
    storage_account_tier  = "Standard"
    storage_replication_type = "LRS"
    # ... more storage options

    # Security
    enable_key_vault      = false
    enable_firewall       = false
    # ... more security options

    # Monitoring
    enable_monitoring     = false
    retention_in_days     = 7

    # Tags
    additional_tags = {
      Tier = "Development"
    }
  }
}
```

### Feature Toggle System

Every resource/module supports **enable/disable flags**:

```hcl
# Enable only what you need
enable_vm          = true      # Deploy VMs
enable_network     = true      # Deploy networking
enable_key_vault   = false     # Skip Key Vault
enable_storage     = true      # Deploy storage
```

---

## 📋 Dynamic Naming Convention

All resource names follow a consistent pattern:

```
<project>-<environment>-<region>-<resource-type>
```

**Examples:**
- `myapp-dev-eastus-vnet` (Virtual Network)
- `myapp-dev-eastus-vm-1` (Virtual Machine)
- `myapp-dev-eastus-kv-a1b2` (Key Vault)
- `myappdeveastusbhst` (Storage Account - no special chars)

This ensures **no naming conflicts** across projects and environments.

---

## 🎛️ Environment Patterns

### Development Environment (dev.tfvars)
- **Purpose**: Testing & development
- **Specs**: Single B2s VM, Standard LRS storage, No redundancy
- **Cost**: ~$20-30/month
- **Security**: Basic NSG rules only
- **Monitoring**: Disabled for cost savings

### Staging Environment (staging.tfvars)
- **Purpose**: Pre-production validation
- **Specs**: 2x B2ms VMs, Standard GRS storage, NAT Gateway
- **Cost**: ~$100-150/month
- **Security**: Key Vault enabled, ACLs enabled
- **Monitoring**: Full monitoring enabled

### Production Environment (prod.tfvars)
- **Purpose**: Live workloads
- **Specs**: 3x D2s v3 VMs, Premium RAGRS storage, Firewall
- **Cost**: ~$500+/month
- **Security**: Premium Key Vault, DDoS protection, Firewall
- **Monitoring**: 1-year retention, advanced monitoring

---

## 📦 Modules Deep Dive

### 1. Network Module (`modules/network/`)

**Deploys:**
- Virtual Network
- Subnets
- Network Security Groups
- Public IPs
- NAT Gateway (optional)
- Azure Bastion (optional)
- DDoS Protection (optional)
- VNet Peering (optional)

**Usage:**
```hcl
module "network" {
  source   = "./modules/network"
  enabled  = var.infrastructure_config[var.environment].enable_network
  
  # Configuration passed from root
}
```

### 2. Compute Module (`modules/compute/`)

**Deploys:**
- Linux Virtual Machines
- Network Interfaces
- Managed Disks (optional)
- Managed Identities (optional)

**Dynamic VM Creation:**
```hcl
# Create 1, 2, or 3 VMs based on config
vm_count = var.infrastructure_config[var.environment].vm_count
```

### 3. Storage Module (`modules/storage/`)

**Deploys:**
- Storage Accounts
- Blob Containers
- File Shares
- Lifecycle Management (automatic tiering)

**Features:**
- Network ACLs for security
- Automatic data tiering (Dev → Archive)
- Lifecycle policies

### 4. Security Module (`modules/security/`)

**Deploys:**
- Key Vault with RBAC
- User-Assigned Managed Identities
- NSG Rules (HTTP, HTTPS, etc.)
- Access Policies

---

## 🔐 Security Best Practices Built-In

✅ **Managed Identities** - No credentials stored  
✅ **RBAC Enabled** - Role-based access control  
✅ **Key Vault Integration** - Secrets management  
✅ **NSG Rules** - Network segmentation  
✅ **DDoS Protection** - Production environments  
✅ **TLS 1.2+** - Encrypted traffic  
✅ **Soft Delete** - Accidental deletion protection  
✅ **Audit Logging** - Compliance tracking  

---

## 🏷️ Tagging Strategy

All resources automatically tagged with:

```hcl
tags = {
  Project       = var.project_name        # "myapp"
  Environment   = var.environment         # "dev", "staging", "prod"
  Owner         = var.owner               # "team@company.com"
  CostCenter    = var.cost_center         # "PROJ-001"
  ManagedBy     = "Terraform"
  CreatedDate   = timestamp()
  # + Additional environment-specific tags
}
```

**Benefits:**
- Cost tracking by project & environment
- Compliance reporting
- Resource governance
- Automated cleanup policies

---

## 🚢 CI/CD Workflows (GitHub Actions)

### 1. Terraform Validate (PR Checks)
```bash
✅ terraform fmt -check
✅ terraform validate
✅ Comment results on PR
```

**Trigger:** Pull requests

### 2. Terraform Plan (PR Preview)
```bash
✅ terraform plan
✅ Display plan in PR comment
✅ No-op validation
```

**Trigger:** Pull requests

### 3. Terraform Apply (CD Pipeline)
```bash
✅ Apply Dev → Staging → Prod
✅ Sequential deployments
✅ Environment gates
```

**Trigger:** Merge to main branch

---

## 🔄 Multi-Project Usage Guide

### Deploy Project 2 (Same Repository, Different Config)

#### Step 1: Create New Environment
```bash
mkdir -p environments/project2-dev
cp environments/dev/dev.tfvars environments/project2-dev/
cp environments/dev/backend.tfbackend environments/project2-dev/
```

#### Step 2: Update tfvars
```hcl
# environments/project2-dev/dev.tfvars
project_name = "projecttwo"     # ← Change this
environment  = "dev"
owner        = "team2@company.com"
# ... other values
```

#### Step 3: Deploy
```bash
terraform plan -var-file=environments/project2-dev/dev.tfvars
terraform apply -var-file=environments/project2-dev/dev.tfvars
```

---

## 🌍 Multi-Region Support

To deploy same infrastructure to multiple regions:

```hcl
# Update infrastructure_config
primary_region   = "eastus"
secondary_region = "westus"

# Enable peering between regions
allow_peering = true
```

**Or deploy separately:**

```bash
# Region 1
terraform apply -var-file=environments/dev/dev.tfvars \
  -var primary_region=eastus

# Region 2
terraform apply -var-file=environments/dev/dev.tfvars \
  -var primary_region=westus
```

---

## 🔄 State Management

### Local State (Development)
```bash
# Default - state stored in terraform.tfstate
terraform init
```

### Remote State (Azure Storage - Recommended)

#### Step 1: Create State Storage Account
```bash
az group create --name terraform-state-rg --location eastus
az storage account create \
  --name tfstatestorageprod \
  --resource-group terraform-state-rg \
  --sku Standard_LRS
az storage container create \
  --name prod-tfstate \
  --account-name tfstatestorageprod
```

#### Step 2: Update Backend Config
```hcl
# environments/prod/backend.tfbackend
resource_group_name  = "terraform-state-rg-prod"
storage_account_name = "tfstatestorageprod"
container_name       = "prod-tfstate"
key                  = "prod.tfstate"
```

#### Step 3: Initialize with Backend
```bash
terraform init \
  -backend-config=environments/prod/backend.tfbackend
```

---

## 📊 Outputs

After deployment, retrieve values:

```bash
# Get all outputs
terraform output

# Get specific output
terraform output network_outputs
terraform output compute_outputs

# Get JSON format
terraform output -json
```

---

## 🛠️ Common Tasks

### Enable Key Vault for Environment
```hcl
# In your tfvars
infrastructure_config = {
  dev = {
    enable_key_vault = true  # ← Change this
    # ...
  }
}
```

### Add 2 More VMs
```hcl
infrastructure_config = {
  production = {
    vm_count = 3  # ← Was 1, now 3
    # ...
  }
}
```

### Change VM Size
```hcl
infrastructure_config = {
  staging = {
    vm_size = "Standard_D2s_v3"  # ← Upgrade from B2s
    # ...
  }
}
```

### Enable Disaster Recovery
```hcl
infrastructure_config = {
  prod = {
    storage_replication_type = "RAGRS"  # Geo-redundant + read access
    enable_backup            = true
    # ...
  }
}
```

---

## 🐛 Troubleshooting

### Error: "Resource already exists"
```bash
# Check remote state
terraform state list

# Import existing resource
terraform import azurerm_resource_group.main /subscriptions/...
```

### Error: "Invalid subscription ID"
```bash
# Set subscription
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Or export as environment variable
export ARM_SUBSCRIPTION_ID="YOUR_SUBSCRIPTION_ID"
```

### SSH Key Issues
```bash
# Generate SSH key
mkdir -p ssh
ssh-keygen -t rsa -b 4096 -f ssh/id_rsa -N ""

# Update compute module to use the key
```

---

## 📈 Scaling to Enterprise

### 10+ Projects
Use **parallel workspaces**:

```bash
terraform workspace new project-alpha
terraform workspace new project-beta
terraform workspace select project-alpha
terraform apply -var-file=environments/deploy/alpha.tfvars
```

### Team Collaboration
- Use **remote state** (Azure Storage)
- Implement **state locking**
- Use **branch protection rules**
- Enable **review gates** in CI/CD

### Cost Optimization
```hcl
# Add auto-shutdown for non-prod
enable_auto_shutdown = var.environment != "prod" ? true : false

# Use cheaper VM sizes for dev
vm_size = var.environment == "dev" ? "Standard_B1s" : "Standard_D2s_v3"
```

---

## ✅ Checklist for New Project

- [ ] Update `project_name` in tfvars
- [ ] Update `azure_subscription_id`
- [ ] Generate SSH keys (`ssh/id_rsa.pub`)
- [ ] Update `owner` email
- [ ] Update `cost_center`
- [ ] Review `infrastructure_config` for your needs
- [ ] Run `terraform init`
- [ ] Run `terraform plan`
- [ ] Review resources to be created
- [ ] Run `terraform apply`

---

## 📝 FAQ

**Q: Can I use this for production?**  
A: Yes! Production configs include all necessary HA, security, and DR features.

**Q: How do I add a new module?**  
A: Create `modules/new-module/main.tf`, add variables, outputs, call in `main.tf`.

**Q: Does this support Windows VMs?**  
A: Yes! Replace `azurerm_linux_virtual_machine` with `azurerm_windows_virtual_machine`.

**Q: Can I use other cloud providers?**  
A: This framework is Azure-specific but patterns apply to AWS/GCP with modifications.

**Q: How do I manage secrets?**  
A: Use the Key Vault module or Terraform Cloud/Enterprise for sensitive variables.

**Q: Is this production-ready?**  
A: Yes! Includes security, RBAC, tagging, monitoring, and CI/CD by default.

---

## 📞 Support & Contribution

For issues, feature requests, or improvements:
- Open GitHub issues
- Submit pull requests
- Follow Terraform best practices
- Test on dev before prod

---

## 📄 License

MIT License - Feel free to use, modify, and distribute.

---

## 🎓 Learning Resources

- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Best Practices](https://learn.microsoft.com/en-us/azure/architecture/framework/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices.html)

---

**Created for multi-project, multi-environment, enterprise-scale infrastructure as code.** 🚀
