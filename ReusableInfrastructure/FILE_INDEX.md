# Repository Contents & File Guide

Complete index of all files in the Reusable Infrastructure Repository.

## 📑 Core Terraform Files (Root Level)

### Configuration Files

| File | Purpose |
|------|---------|
| `versions.tf` | Terraform & provider versions, backend config |
| `provider.tf` | Azure provider configuration & features |
| `variables.tf` | Core infrastructure configuration schema |
| `locals.tf` | Local values, naming conventions, common tags |
| `main.tf` | Module orchestration & resource group |
| `outputs.tf` | Output definitions for all deployed resources |

### Project Files

| File | Purpose |
|------|---------|
| `.gitignore` | Git ignore rules (state, SSH keys, secrets) |
| `Makefile` | Convenient Terraform commands |

---

## 📁 Modular Architecture

### Network Module (`modules/network/`)

**File:** `main.tf`

**Features:**
- Virtual Networks with custom CIDR blocks
- Subnets with dynamic IP allocation
- Network Security Groups with default rules
- Public IPs for outbound connectivity
- NAT Gateway for secure outbound (optional)
- Azure Bastion for secure admin access (optional)
- DDoS Protection Standard (optional)
- VNet Peering for network connectivity (optional)

**Key Variables:**
- `enabled` - Enable/disable module
- `vpc_cidr` - Network CIDR block
- `enable_nat_gateway` - NAT Gateway toggle
- `enable_bastion` - Bastion host toggle
- `enable_ddos_standard` - DDoS protection toggle

**Outputs:**
- `vnet_id` - Virtual Network ID
- `subnet_id_primary` - Primary subnet ID
- `nsg_id` - Network Security Group ID
- `public_ip_address` - Allocated public IP

---

### Compute Module (`modules/compute/`)

**File:** `main.tf`

**Features:**
- Linux Virtual Machines
- Network Interfaces
- Managed Disks (OS and data)
- Managed Identity (System-assigned)
- SSH key-based authentication
- Multiple VMs via count

**Key Variables:**
- `enabled` - Enable/disable module
- `vm_count` - Number of VMs to create (1-100)
- `vm_size` - Azure VM size (B2s, D2s_v3, etc.)
- `vm_image` - Image publisher, offer, SKU
- `additional_data_disks` - Extra data disks to attach

**Outputs:**
- `vm_ids` - List of VM IDs
- `vm_names` - List of VM names
- `vm_private_ips` - Local network IPs
- `network_interface_ids` - NIC IDs

---

### Storage Module (`modules/storage/`)

**File:** `main.tf`

**Features:**
- Storage Accounts (StorageV2, Blob, Archive)
- Blob Containers with access control
- File Shares for SMB access
- Lifecycle Management (auto-tiering)
- Network ACLs for security
- HTTPS enforcement

**Key Variables:**
- `enabled` - Enable/disable module
- `storage_account_kind` - Storage type (StorageV2, BlobStorage)
- `storage_account_tier` - Performance tier (Standard, Premium)
- `replication_type` - Redundancy (LRS, GRS, RAGRS, ZRS)
- `enable_blob_container` - Deploy blob storage
- `enable_file_share` - Deploy file share

**Outputs:**
- `storage_account_id` - Storage account ID
- `storage_account_name` - Storage account name
- `blob_container_id` - Blob container ID
- `storage_access_key` - Access key (sensitive)

---

### Security Module (`modules/security/`)

**File:** `main.tf`

**Features:**
- Azure Key Vault with RBAC
- User-Assigned Managed Identities
- NSG Security Rules (HTTP, HTTPS, SSH, RDP)
- Network ACLs
- Purge protection & soft delete
- Automatic secret management

**Key Variables:**
- `enabled` - Enable/disable module
- `enable_key_vault` - Deploy Key Vault
- `key_vault_sku` - SKU (standard, premium)
- `enable_nsg` - Configure NSG rules
- `enable_firewall` - Firewall configuration

**Outputs:**
- `key_vault_id` - Key Vault ID
- `key_vault_uri` - Key Vault URI
- `managed_identity_id` - Identity ID
- `managed_identity_principal_id` - Principal ID

---

## 🌍 Environment Configurations

### Dev Environment (`environments/dev/`)

| File | Purpose |
|------|---------|
| `dev.tfvars` | Development configuration (1 B2s VM, LRS storage, no backup) |
| `backend.tfbackend` | Backend config for local state |

**Cost:** ~$20-30/month

---

### Staging Environment (`environments/staging/`)

| File | Purpose |
|------|---------|
| `staging.tfvars` | Staging configuration (2 B2ms VMs, GRS storage) |
| `backend.tfbackend` | Backend config for Azure Storage |

**Cost:** ~$100-150/month

---

### Production Environment (`environments/prod/`)

| File | Purpose |
|------|---------|
| `prod.tfvars` | Production configuration (3 D2s VMs, RAGRS storage, HA) |
| `backend.tfbackend` | Backend config for Azure Storage |

**Cost:** ~$500+/month

---

## 🔄 CI/CD Pipeline

### GitHub Actions Workflows (`.github/workflows/`)

| File | Trigger | Purpose |
|------|---------|---------|
| `terraform-validate.yml` | Pull Request | Format & syntax validation |
| `terraform-plan.yml` | Pull Request | Show deployment preview |
| `terraform-apply.yml` | Push to main | Deploy to all environments |

---

## 📚 Documentation

### Quick References

| File | Audience | Content |
|------|----------|---------|
| `README.md` | All | Complete guide, features, patterns |
| `QUICK_START.md` | New users | 5-minute setup instructions |
| `FAQ.md` | All | Common questions & answers |
| `MODULE_GUIDE.md` | Developers | Module creation & extension |
| `DEPLOYMENT_GUIDE.md` | DevOps | Production deployment checklist |
| `CONTRIBUTING.md` | Contributors | Development workflow & standards |

---

## 📋 Reference Files

### Templates

| File | Purpose |
|------|---------|
| `templates/example.tfvars` | Template for new environment configs |

### SSH Keys

| File | Purpose |
|------|---------|
| `ssh/.gitkeep` | SSH key directory marker |

---

## 📊 File Organization Summary

```
ReusableInfrastructure/
│
├── Core Terraform (6 files)
│   ├── versions.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── locals.tf
│   ├── main.tf
│   └── outputs.tf
│
├── modules/ (4 modules)
│   ├── network/main.tf
│   ├── compute/main.tf
│   ├── storage/main.tf
│   └── security/main.tf
│
├── environments/ (3 environments)
│   ├── dev/
│   │   ├── dev.tfvars
│   │   └── backend.tfbackend
│   ├── staging/
│   │   ├── staging.tfvars
│   │   └── backend.tfbackend
│   └── prod/
│       ├── prod.tfvars
│       └── backend.tfbackend
│
├── .github/workflows/ (3 workflows)
│   ├── terraform-validate.yml
│   ├── terraform-plan.yml
│   └── terraform-apply.yml
│
├── templates/
│   └── example.tfvars
│
├── ssh/
│   └── .gitkeep
│
├── Documentation (6 files)
│   ├── README.md
│   ├── QUICK_START.md
│   ├── FAQ.md
│   ├── MODULE_GUIDE.md
│   ├── DEPLOYMENT_GUIDE.md
│   └── CONTRIBUTING.md
│
├── Configuration
│   ├── .gitignore
│   └── Makefile
│
└── Project Files
    ├── .gitignore
    └── Makefile
```

---

## 🚀 Getting Started Workflow

1. **First Time?** → Read [QUICK_START.md](QUICK_START.md)
2. **Need Details?** → See [README.md](README.md)
3. **Have Questions?** → Check [FAQ.md](FAQ.md)
4. **Building Modules?** → Study [MODULE_GUIDE.md](MODULE_GUIDE.md)
5. **Going to Prod?** → Follow [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
6. **Contributing?** → Review [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📦 Key Features Checklist

### Configuration-Driven ✓
- Single `infrastructure_config` object controls everything
- Feature toggles for all resources
- No hardcoded values anywhere

### Multi-Environment ✓
- Dev, Staging, Prod with unique configs
- Different resource sizes & features per env
- Cost optimization per environment tier

### Multi-Region ✓
- Dynamic region selection
- Support for multiple Azure regions
- Network peering support

### Multi-Project ✓
- Unique naming per project
- Dynamic resource naming convention
- Isolated cost tracking

### Enterprise-Ready ✓
- RBAC & managed identities
- Key Vault for secrets
- Full monitoring & alerting
- Disaster recovery features
- Network security (NSGs, firewalls)
- DDoS protection (prod)

### CI/CD Ready ✓
- GitHub Actions workflows included
- Automated validation & planning
- Multi-environment deployment pipeline
- Environment gates & approval

### Documentation ✓
- 6 comprehensive guides
- Module development guide
- Production deployment checklist
- Troubleshooting FAQ

---

## 📝 Important Files to Customize

When setting up a new project:

1. **Update environment variables:**
   - `environments/dev/dev.tfvars`
   - `environments/staging/staging.tfvars`
   - `environments/prod/prod.tfvars`

2. **Generate SSH keys:**
   - Run: `ssh-keygen -t rsa -b 4096 -f ssh/id_rsa -N ""`

3. **Configure backend (optional):**
   - `environments/*/backend.tfbackend`

4. **Customize modules (if needed):**
   - `modules/*/main.tf`

---

## ✅ Deployment Checklist

Before your first deployment:

- [ ] Clone repository
- [ ] Review & update environment tfvars
- [ ] Generate SSH keys
- [ ] Run `terraform init`
- [ ] Run `terraform plan`
- [ ] Review proposed resources
- [ ] Run `terraform apply`
- [ ] Verify outputs with `terraform output`
- [ ] Test connectivity (SSH to VM)
- [ ] Enable monitoring (if needed)
- [ ] Configure backups

---

**This repository contains everything needed for production-grade infrastructure deployment across multiple projects, environments, and regions.**

For any questions, see [FAQ.md](FAQ.md) or [README.md](README.md).

Happy terraforming! 🚀
