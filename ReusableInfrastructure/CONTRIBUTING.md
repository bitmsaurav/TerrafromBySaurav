# Contributing Guide

Thank you for contributing to this Terraform infrastructure repository!

## Development Workflow

### 1. Fork & Clone

```bash
git clone https://github.com/your-fork/terraform-infra.git
cd terraform-infra
git checkout -b feature/my-feature
```

### 2. Make Changes

Follow these principles:

- **No hardcoding** - Use variables for all values
- **DRY principle** - Create modules instead of duplicating code
- **Documentation** - Document purpose and usage
- **Testing** - Test changes on all environments

### 3. Code Quality

```bash
# Format code
make fmt

# Validate syntax
make validate

# Lint with tflint (if installed)
make lint

# Plan changes
make plan ENVIRONMENT=dev
```

### 4. Commit & Push

```bash
git add .
git commit -m "feat: add key-vault-backup module"
git push origin feature/my-feature
```

### 5. Create Pull Request

- Describe changes clearly
- Reference issues if applicable
- Ensure CI/CD checks pass

### 6. Merge

After review and approval, merge to `main` branch.

---

## Coding Standards

### Variable Naming

```hcl
# ✅ Good
variable "enable_backup" { }
variable "storage_account_name" { }
variable "vm_size" { }

# ❌ Bad
variable "backup" { }
variable "storage" { }
variable "size" { }
```

### Resource Naming

```hcl
# ✅ Good - Use local variables for dynamic naming
resource "azurerm_storage_account" "main" {
  name = "${local.name_prefix}-storage"
}

# ❌ Bad - Hardcoded names
resource "azurerm_storage_account" "main" {
  name = "myprojectstorage2024"
}
```

### Module Structure

Each module must have:

```
module-name/
├── main.tf         # Resource definitions
├── variables.tf    # Input variables (with descriptions)
├── outputs.tf      # Output definitions (with descriptions)  
└── README.md       # Usage documentation
```

### Documentation

```hcl
variable "enable_backup" {
  description = "Enable automated backups (30-day retention)"
  type        = bool
  default     = false
  
  # Optional: expanded explanation
  # When enabled, automatic daily backups are configured
  # with 30-day retention. Backups can be restored to any
  # point in time within the retention window.
}

output "storage_account_id" {
  description = "Unique identifier for the storage account"
  value       = azurerm_storage_account.main.id
  sensitive   = false
}
```

---

## Creating New Modules

### Step 1: Create Directory

```bash
mkdir -p modules/database
```

### Step 2: minimal Template

**modules/database/variables.tf:**
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50.0"
    }
  }
}

variable "enabled" {
  description = "Enable/disable this module"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

# ... more variables
```

**modules/database/main.tf:**
```hcl
resource "azurerm_postgresql_server" "main" {
  count = var.enabled ? 1 : 0
  
  name                = var.server_name
  resource_group_name = var.resource_group_name
  
  # ... resource configuration
  
  tags = var.tags
}
```

**modules/database/outputs.tf:**
```hcl
output "server_id" {
  value       = try(azurerm_postgresql_server.main[0].id, null)
  description = "PostgreSQL Server ID"
}
```

### Step 3: Add to Root

In **main.tf**:
```hcl
module "database" {
  source = "./modules/database"
  
  enabled = var.infrastructure_config[var.environment].enable_database
  
  # ... wiring
}
```

---

## Testing Checklist

Before submitting:

- [ ] Code formatted: `make fmt`
- [ ] Syntax valid: `make validate`
- [ ] Plan clean: `make plan ENVIRONMENT=dev`
- [ ] Applied successfully: `make apply ENVIRONMENT=dev`
- [ ] Outputs correct: `make output ENVIRONMENT=dev`
- [ ] No hardcoded values
- [ ] Documentation added
- [ ] Variables validated
- [ ] Tags applied correctly

---

## Commit Message Format

Follow conventional commits:

```
feat: add database module with backup support
fix: correct NSG rule priority values
docs: update README with new module documentation
refactor: consolidate naming logic into locals
chore: upgrade Terraform provider version
```

---

## PR Review Criteria

Reviews check for:

1. **Functionality** - Does it work as intended?
2. **Code Quality** - Follows standards & best practices?
3. **Documentation** - Clear comments & descriptions?
4. **Security** - No hardcoded secrets or vulnerabilities?
5. **Testing** - Changes tested on target environments?
6. **Reusability** - Can others use this module?

---

## Red Flags

We cannot accept PRs with:

- ❌ Hardcoded subscription IDs
- ❌ Hardcoded secrets or passwords
- ❌ Hardcoded resource names
- ❌ Hardcoded ARM_* environment variables
- ❌ Enabled sensitive outputs without clear reason
- ❌ Modules without `enabled` flag
- ❌ Missing documentation
- ❌ Untested code
- ❌ Inconsistent naming conventions

---

## Questions?

- Check [FAQ.md](FAQ.md) for common questions
- See [MODULE_GUIDE.md](MODULE_GUIDE.md) for advanced usage
- Review existing modules for examples

---

## License

By contributing, you agree your code is available under MIT License.

**Happy contributing! 🚀**
