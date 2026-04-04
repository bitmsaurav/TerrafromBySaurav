locals {
  # Naming convention
  resource_prefix = var.resource_prefix
  environment     = terraform.workspace
  deployment_slot = var.deployment_slot != "" ? "-${var.deployment_slot}" : ""
  location_short  = {
    "Central India" = "cin"
    "East US"       = "eus"
    "West Europe"   = "weu"
  }

  # Resource group names
  resource_groups = {
    for region in var.regions : region => "${local.resource_prefix}-${local.environment}${local.deployment_slot}-${local.location_short[region]}-rg"
  }

  common_tags = {
    Environment     = local.environment
    DeploymentSlot  = var.deployment_slot
    Owner           = var.owner
    CostCenter      = var.cost_center
    Project         = var.project
    ManagedBy       = "Terraform"
  }
}