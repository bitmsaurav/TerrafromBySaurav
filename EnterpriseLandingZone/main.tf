resource "azurerm_resource_group" "region" {
  for_each = local.region_resource_groups

  name     = each.value.name
  location = each.value.location
  tags     = local.common_tags
}

module "vnet" {
  source   = "./modules/vnet"
  for_each = local.regions

  enabled             = true
  resource_group_name = azurerm_resource_group.region[each.key].name
  location            = each.value.location
  name                = format("%s-%s-vnet-%s%s", var.project_name, each.value.role, each.key, local.deployment_slot_suffix)
  address_space       = [each.value.vnet_cidr]
  tags                = local.common_tags
}

module "nsg" {
  source   = "./modules/nsg"
  for_each = local.regions

  enabled             = true
  resource_group_name = azurerm_resource_group.region[each.key].name
  location            = each.value.location
  name                = format("%s-%s-nsg-%s%s", var.project_name, each.value.role, each.key, local.deployment_slot_suffix)
  rules               = each.value.nsg_rules
  tags                = local.common_tags
}

module "subnet" {
  source   = "./modules/subnet"
  for_each = local.regions

  enabled              = true
  resource_group_name  = azurerm_resource_group.region[each.key].name
  location             = each.value.location
  virtual_network_name = module.vnet[each.key].name
  subnets              = each.value.subnets
  nsg_id               = module.nsg[each.key].nsg_id
  tags                 = local.common_tags
}

module "vm" {
  source   = "./modules/vm"
  for_each = local.provisioned_vm_regions

  enabled                 = true
  resource_group_name     = azurerm_resource_group.region[each.key].name
  location                = each.value.location
  name                    = format("%s-%s-vm-%s%s", var.project_name, each.value.role, each.key, local.deployment_slot_suffix)
  vm_count                = each.value.vm_count
  vm_size                 = each.value.vm_size
  vm_os_disk_type         = each.value.vm_os_disk_type
  vm_image                = each.value.vm_image
  subnet_id               = module.subnet[each.key].subnet_ids[each.value.default_subnet]
  enable_public_ip        = each.value.enable_public_ip
  enable_managed_identity = true
  admin_username          = "azureuser"
  ssh_public_key_path     = var.ssh_public_key_path
  tags                    = local.common_tags
}

module "security" {
  source = "./modules/security"

  enabled                       = true
  resource_group_name           = azurerm_resource_group.region[local.hub_region_key].name
  location                      = azurerm_resource_group.region[local.hub_region_key].location
  key_vault_name                = format("%s-kv-%s%s", var.project_name, var.environment, local.deployment_slot_suffix)
  enable_key_vault              = true
  access_policies               = {}
  enable_user_assigned_identity = true
  identity_name                 = format("%s-identity-%s%s", var.project_name, var.environment, local.deployment_slot_suffix)
  role_assignments              = var.security_role_assignments
  tags                          = local.common_tags
}

module "monitoring" {
  source = "./modules/monitoring"

  enabled             = local.env_settings.enable_monitoring
  resource_group_name = azurerm_resource_group.region[local.hub_region_key].name
  location            = azurerm_resource_group.region[local.hub_region_key].location
  log_analytics_name  = format("%s-law-%s%s", var.project_name, var.environment, local.deployment_slot_suffix)
  retention_in_days   = 30
  enable_app_insights = true
  app_insights_name   = format("%s-ai-%s%s", var.project_name, var.environment, local.deployment_slot_suffix)
  policy_definitions  = var.policy_definitions
  tags                = local.common_tags
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  for_each = local.env_settings.enable_vnet_peering ? { for region_key, config in local.regions : region_key => config if config.role == "spoke" } : {}

  name                      = format("%s-to-%s-peering", each.key, local.hub_region_key)
  resource_group_name       = azurerm_resource_group.region[each.key].name
  virtual_network_name      = module.vnet[each.key].name
  remote_virtual_network_id = module.vnet[local.hub_region_key].id

  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  allow_virtual_network_access = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  for_each = local.env_settings.enable_vnet_peering ? { for region_key, config in local.regions : region_key => config if config.role == "spoke" } : {}

  name                      = format("%s-to-%s-peering", local.hub_region_key, each.key)
  resource_group_name       = azurerm_resource_group.region[local.hub_region_key].name
  virtual_network_name      = module.vnet[local.hub_region_key].name
  remote_virtual_network_id = module.vnet[each.key].id

  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  allow_virtual_network_access = true
  use_remote_gateways          = false
}
