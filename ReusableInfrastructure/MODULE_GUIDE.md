# Module Development Guide

Learn how to create, customize, and extend modules for this framework.

## Module Architecture

Each module is a self-contained, reusable Terraform component with:

```
module-name/
├── main.tf          # Resource definitions
├── variables.tf     # Input variables
└── outputs.tf       # Output values
```

### Design Principles

1. **Independence** - Module works without other modules
2. **Flexibility** - Supports multiple use cases via variables
3. **Enable/Disable** - Has `enabled` flag for feature toggles
4. **Clear Interface** - Well-defined inputs and outputs
5. **DRY** - Reusable, no hardcoding

---

## Anatomy of a Module

### Example: Network Module (`modules/network/`)

#### 1. Variables (Inputs)

```hcl
variable "enabled" {
  description = "Enable/disable this module"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
}

variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
}

# ... more variables
```

**Key Points:**
- Always include `enabled` flag
- Use clear, descriptive names
- Add validation rules where appropriate

#### 2. Resources (Logic)

```hcl
resource "azurerm_virtual_network" "main" {
  count = var.enabled ? 1 : 0  # Enable/disable pattern

  name                = var.vnet_name
  address_space       = [var.vpc_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}
```

**Key Points:**
- Use `count` for enable/disable
- Use consistent resource names (e.g., `main`, `secondary`)
- Always apply tags
- Use `depends_on` for explicit dependencies

#### 3. Outputs (Exports)

```hcl
output "vnet_id" {
  value       = try(azurerm_virtual_network.main[0].id, null)
  description = "Virtual Network ID"
}

output "vnet_name" {
  value       = try(azurerm_virtual_network.main[0].name, null)
  description = "Virtual Network name"
}

# ... more outputs
```

**Key Points:**
- Use `try()` to handle disabled modules gracefully
- Return `null` if module disabled
- Export all important resource IDs
- Document every output

---

## Creating a New Module

### Step 1: Create Module Directory

```bash
mkdir -p modules/database
```

### Step 2: Create variables.tf

```hcl
# modules/database/variables.tf

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

variable "location" {
  description = "Azure region"
  type        = string
}

variable "server_name" {
  description = "Database server name"
  type        = string
}

variable "database_version" {
  description = "Database version"
  type        = string
  default     = "11"
  validation {
    condition     = contains(["11", "12", "13", "14"], var.database_version)
    error_message = "Version must be 11, 12, 13, or 14"
  }
}

variable "enable_backup" {
  description = "Enable automated backups"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
```

### Step 3: Create main.tf

```hcl
# modules/database/main.tf

resource "azurerm_postgresql_server" "main" {
  count = var.enabled ? 1 : 0

  name                = var.server_name
  location            = var.location
  resource_group_name = var.resource_group_name
  version             = var.database_version
  
  sku_name   = "B_Gen5_1"
  storage_mb = 51200

  backup_retention_days             = var.enable_backup ? 30 : 7
  geo_redundant_backup_enabled      = var.enable_backup
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  administrator_login               = "psqladmin"
  administrator_login_password      = random_password.admin[0].result

  tags = var.tags

  depends_on = []
}

resource "random_password" "admin" {
  count   = var.enabled ? 1 : 0
  length  = 32
  special = true
}
```

### Step 4: Create outputs.tf

```hcl
# modules/database/outputs.tf

output "server_id" {
  value       = try(azurerm_postgresql_server.main[0].id, null)
  description = "PostgreSQL Server ID"
}

output "server_fqdn" {
  value       = try(azurerm_postgresql_server.main[0].fqdn, null)
  description = "PostgreSQL Server FQDN"
}

output "server_name" {
  value       = try(azurerm_postgresql_server.main[0].name, null)
  description = "PostgreSQL Server name"
}
```

### Step 5: Call Module in main.tf

```hcl
# In root main.tf

module "database" {
  source = "./modules/database"

  enabled = var.infrastructure_config[var.environment].enable_database

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  server_name         = "${local.name_prefix}-db"
  database_version    = "14"
  enable_backup       = local.env_config.enable_backup

  tags = local.common_tags

  depends_on = [azurerm_resource_group.main]
}
```

---

## Module Best Practices

### 1. Use Dynamic Naming

```hcl
# ❌ Bad - Hardcoded names
resource "azurerm_virtual_machine" "main" {
  name = "production-vm-1"
}

# ✅ Good - Dynamic naming
resource "azurerm_virtual_machine" "main" {
  name = "${var.vm_name}-${count.index + 1}"
}
```

### 2. Support for_each When Needed

```hcl
# Example: Multiple databases
resource "azurerm_postgresql_database" "main" {
  for_each = var.databases_config

  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.main[0].name
  charset             = each.value.charset
  collation           = each.value.collation
}
```

### 3. Use Sensible Defaults

```hcl
variable "enable_backup" {
  description = "Enable backups"
  type        = bool
  default     = true        # Default to secure option
}

variable "retention_days" {
  description = "Retention days"
  type        = number
  default     = 30          # Sensible default
}
```

### 4. Add Input Validation

```hcl
variable "vm_size" {
  description = "VM size"
  type        = string
  default     = "Standard_B2s"
  
  validation {
    condition     = contains(["Standard_B2s", "Standard_D2s_v3"], var.vm_size)
    error_message = "Only B2s and D2s_v3 sizes allowed"
  }
}
```

### 5. Handle Optional Resources Gracefully

```hcl
# Use count for optional features
resource "azurerm_backup_policy_vm" "main" {
  count = var.enabled && var.enable_backup ? 1 : 0
  ...
}

# Use try() in outputs
output "backup_policy_id" {
  value = try(azurerm_backup_policy_vm.main[0].id, null)
}
```

### 6. Document Everything

```hcl
variable "database_tier" {
  description = "Database tier (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
  
  # Detailed comments help team members
  # Basic: Dev/test workloads
  # Standard: Production workloads
  # Premium: Mission-critical workloads
}
```

---

## Module Testing

### Local Testing

```bash
# Navigate to module
cd modules/network

# Validate syntax
terraform init -backend=false
terraform validate

# Format check
terraform fmt -check -recursive
```

### Integration Testing

```bash
# Test complete stack
terraform plan -var-file=environments/dev/dev.tfvars
terraform apply -var-file=environments/dev/dev.tfvars

# Verify module outputs
terraform output network_outputs
```

---

## Advanced Module Patterns

### 1. Conditional Module Outputs

```hcl
output "primary_endpoint" {
  description = "Primary endpoint (null if disabled)"
  value = var.enabled ? {
    id   = azurerm_virtual_machine.main[0].id
    name = azurerm_virtual_machine.main[0].name
  } : null
}
```

### 2. Complex Type Variables

```hcl
variable "tier_configs" {
  description = "Tier-specific configurations"
  type = map(object({
    vm_count     = number
    vm_size      = string
    disk_size    = number
    enable_backup = bool
  }))
  
  default = {
    dev = {
      vm_count      = 1
      vm_size       = "Standard_B2s"
      disk_size     = 128
      enable_backup = false
    }
    prod = {
      vm_count      = 3
      vm_size       = "Standard_D2s_v3"
      disk_size     = 512
      enable_backup = true
    }
  }
}
```

### 3. Dynamic Blocks

```hcl
resource "azurerm_network_security_group" "main" {
  count = var.enabled ? 1 : 0

  dynamic "security_rule" {
    for_each = var.security_rules
    
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.key + 100
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port
      destination_port_range     = security_rule.value.dest_port
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}
```

---

## Extending Existing Modules

### Add New Optional Feature

```hcl
# In modules/network/variables.tf
variable "enable_flow_logs" {
  description = "Enable NSG flow logs"
  type        = bool
  default     = false
}

# In modules/network/main.tf
resource "azurerm_network_watcher_flow_log" "main" {
  count = var.enabled && var.enable_flow_logs ? 1 : 0
  
  network_watcher_name      = azurerm_network_watcher.main[0].name
  network_security_group_id = azurerm_network_security_group.main[0].id
  # ... rest of config
}
```

### Add Performance Optimization

```hcl
# Add caching configuration
resource "azurerm_redis_cache" "main" {
  count = var.enabled && var.enable_cache ? 1 : 0
  
  name                = var.cache_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.cache_capacity
  family              = var.cache_family
  sku_name            = var.cache_sku
  
  # Disable redundancy for dev
  zones = var.enable_high_availability ? ["1", "2", "3"] : null
}
```

---

## Module Versioning

```hcl
# Reference module with version
module "network" {
  source = "git::https://github.com/company/terraform-modules.git//network?ref=v1.2.0"
  
  # Variables...
}
```

---

## Publishing Modules

```bash
# Initialize as Terraform module
mkdir -p terraform-azure-modules/modules/network
cd terraform-azure-modules/modules/network

# Add required files
touch main.tf variables.tf outputs.tf

# Create terraform-docs
echo '# Network Module' > README.md

# Tag for release
git tag v1.0.0
git push origin v1.0.0
```

---

## Common Pitfalls

❌ **Hardcoding values** - Use variables instead  
❌ **No enable/disable flag** - Always support feature toggle  
❌ **Missing try() in outputs** - Handle disabled modules  
❌ **No input validation** - Prevent invalid configurations  
❌ **Poor documentation** - Comment your code  
❌ **No error handling** - Use depends_on and error messages  

---

See [README.md](README.md) for complete documentation.
