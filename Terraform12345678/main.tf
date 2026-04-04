# Resource Groups
resource "azurerm_resource_group" "this" {
  for_each = toset(var.regions)

  name     = local.resource_groups[each.key]
  location = each.key

  tags = local.common_tags
}

# VNet Module
module "vnet" {
  source = "./modules/vnet"

  vnets    = var.vnets
  subnets  = var.subnets
  common_tags = local.common_tags
}

# NSG Module
module "nsg" {
  source = "./modules/nsg"

  nsgs                     = var.nsgs
  subnet_nsg_associations  = var.subnet_nsg_associations
  common_tags              = local.common_tags
}

# VM Module
module "vm" {
  source = "./modules/vm"

  vms         = var.vms
  common_tags = local.common_tags
}

# Monitoring Module
module "monitoring" {
  source = "./modules/monitoring"

  log_analytics_workspaces = var.log_analytics_workspaces
  diagnostic_settings      = var.diagnostic_settings
  common_tags              = local.common_tags
}

# Security Module
module "security" {
  source = "./modules/security"

  policy_definitions = var.policy_definitions
  policy_assignments  = var.policy_assignments
  common_tags         = local.common_tags
}

# Storage Module
module "storage" {
  source = "./modules/storage"

  storage_accounts   = var.storage_accounts
  storage_containers = var.storage_containers
  common_tags        = local.common_tags
}

# Load Balancer Module
module "loadbalancer" {
  source = "./modules/loadbalancer"

  public_ips            = var.public_ips
  load_balancers        = var.load_balancers
  backend_address_pools = var.backend_address_pools
  probes                = var.probes
  rules                 = var.rules
  common_tags           = local.common_tags
}