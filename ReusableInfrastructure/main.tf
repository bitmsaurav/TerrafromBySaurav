###############################################################################
# MAIN ORCHESTRATION - Module composition
###############################################################################

# Azure Resource Group
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.primary_region
  tags     = local.common_tags
}

# Network Module
module "network" {
  source = "./modules/network"

  # Control module deployment
  enabled = local.env_config.enable_network

  # Core identifiers
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  # Network configuration
  vnet_name      = local.vnet_name
  vpc_cidr       = local.env_config.vpc_cidr
  subnet_name    = local.subnet_name
  nsg_name       = local.nsg_name
  public_ip_name = local.public_ip_name
  nic_name       = local.nic_name

  # Features
  enable_nat_gateway   = local.env_config.enable_nat_gateway
  enable_bastion       = local.env_config.enable_bastion
  enable_ddos_standard = local.env_config.enable_ddos_standard

  # Optional configuration
  custom_dns_servers = var.custom_dns_servers
  enable_peering     = var.allow_peering
  peering_vnets      = var.peering_vnets

  # Tagging
  tags = merge(
    local.common_tags,
    local.env_config.additional_tags
  )

  depends_on = [azurerm_resource_group.main]
}

# Compute Module (VMs)
module "compute" {
  source = "./modules/compute"

  # Control module deployment
  enabled = local.env_config.enable_vm

  # Core identifiers
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  # VM configuration
  vm_name         = local.vm_name
  nic_name        = local.nic_name
  vm_count        = local.env_config.vm_count
  vm_size         = local.env_config.vm_size
  vm_os_disk_type = local.env_config.vm_os_disk_type

  vm_image = {
    publisher = local.env_config.vm_image_publisher
    offer     = local.env_config.vm_image_offer
    sku       = local.env_config.vm_image_sku
    version   = local.env_config.vm_image_version
  }

  enable_managed_disk   = local.env_config.enable_managed_disk
  additional_data_disks = local.env_config.additional_data_disks

  # Network configuration
  subnet_id        = module.network.subnet_id_primary
  nsg_id           = module.network.nsg_id
  enable_public_ip = local.env_config.enable_vm && var.environment != "dev" ? true : false

  # Security
  enable_managed_identity = var.enable_managed_identity

  # Tagging
  tags = merge(
    local.common_tags,
    local.env_config.additional_tags
  )

  depends_on = [azurerm_resource_group.main, module.network]
}

# Storage Module
module "storage" {
  source = "./modules/storage"

  # Control module deployment
  enabled = local.env_config.enable_storage

  # Core identifiers
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  # Storage configuration
  storage_account_name = local.storage_account_name
  account_kind         = local.env_config.storage_account_kind
  account_tier         = local.env_config.storage_account_tier
  replication_type     = local.env_config.storage_replication_type

  # Blob configuration
  enable_blob_container      = local.env_config.enable_blob_container
  blob_container_name        = "${local.name_prefix}-container"
  blob_container_access_type = local.env_config.blob_container_access_type

  # File Share configuration
  enable_file_share = local.env_config.enable_file_share
  file_share_name   = "${local.name_prefix}-share"
  file_share_quota  = local.env_config.file_share_quota

  # Network security
  enable_acl = local.env_config.enable_network_security

  # Tagging
  tags = merge(
    local.common_tags,
    local.env_config.additional_tags
  )

  depends_on = [azurerm_resource_group.main]
}

# Security Module (Key Vault, NSG rules, etc)
module "security" {
  source = "./modules/security"

  # Control module deployment
  enabled = local.env_config.enable_key_vault || local.env_config.enable_network_security

  # Core identifiers
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  # Key Vault configuration
  enable_key_vault = local.env_config.enable_key_vault
  key_vault_name   = local.keyvault_name
  key_vault_sku    = local.env_config.key_vault_sku

  # NSG configuration
  enable_nsg = local.env_config.enable_network_security
  nsg_id     = module.network.nsg_id
  nsg_name   = local.nsg_name

  # Network rules
  enable_firewall = local.env_config.enable_firewall

  # Tagging
  tags = merge(
    local.common_tags,
    local.env_config.additional_tags
  )

  depends_on = [azurerm_resource_group.main, module.network]
}
