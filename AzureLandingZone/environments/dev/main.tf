terraform {
  backend "azurerm" {
    resource_group_name  = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = "dev.terraform.tfstate"
  }
}

locals {
  common_tags = merge(var.tags, {
    environment = "dev"
  })
}

module "rg" {
  source = "../../modules/rg"
  resource_groups = var.resource_groups
  tags = local.common_tags
  providers = {
    azurerm = azurerm.primary
  }
}

module "vnet" {
  source = "../../modules/vnet"
  virtual_networks = var.virtual_networks
  tags = local.common_tags
  providers = {
    azurerm = azurerm.primary
  }
}

# Add other modules as needed