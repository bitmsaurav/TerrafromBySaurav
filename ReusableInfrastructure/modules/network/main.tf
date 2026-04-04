###############################################################################
# Network Module - Virtual Networks, Subnets, NSGs, Bastion, NAT Gateway
###############################################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50.0"
    }
  }
}

# Control whether this module is deployed
variable "enabled" {
  description = "Enable/disable this module"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VNet"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "nsg_name" {
  description = "Network Security Group name"
  type        = string
}

variable "public_ip_name" {
  description = "Public IP name"
  type        = string
}

variable "nic_name" {
  description = "Network Interface name"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for outbound connectivity"
  type        = bool
  default     = false
}

variable "enable_bastion" {
  description = "Enable Azure Bastion for secure remote access"
  type        = bool
  default     = false
}

variable "enable_ddos_standard" {
  description = "Enable DDoS Standard protection"
  type        = bool
  default     = false
}

variable "custom_dns_servers" {
  description = "Custom DNS servers"
  type        = list(string)
  default     = []
}

variable "enable_peering" {
  description = "Enable VNet peering"
  type        = bool
  default     = false
}

variable "peering_vnets" {
  description = "VNets to peer with"
  type = map(object({
    resource_group_name = string
    vnet_name           = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  count = var.enabled ? 1 : 0

  name                = var.vnet_name
  address_space       = [var.vpc_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_servers         = var.custom_dns_servers

  tags = var.tags
}

# Subnets
resource "azurerm_subnet" "main" {
  count = var.enabled ? 1 : 0

  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [cidrsubnet(var.vpc_cidr, 2, 0)]
}

# Bastion Subnet (if Bastion enabled)
resource "azurerm_subnet" "bastion" {
  count = var.enabled && var.enable_bastion ? 1 : 0

  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [cidrsubnet(var.vpc_cidr, 2, 1)]
}

# Network Security Group
resource "azurerm_network_security_group" "main" {
  count = var.enabled ? 1 : 0

  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Default security rules
resource "azurerm_network_security_rule" "allow_ssh" {
  count = var.enabled ? 1 : 0

  name                        = "AllowSSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main[0].name
}

resource "azurerm_network_security_rule" "allow_rdp" {
  count = var.enabled ? 1 : 0

  name                        = "AllowRDP"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main[0].name
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "main" {
  count = var.enabled ? 1 : 0

  subnet_id                 = azurerm_subnet.main[0].id
  network_security_group_id = azurerm_network_security_group.main[0].id
}

# Public IP (for NAT Gateway and/or VM)
resource "azurerm_public_ip" "main" {
  count = var.enabled ? 1 : 0

  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

# NAT Gateway
resource "azurerm_nat_gateway" "main" {
  count = var.enabled && var.enable_nat_gateway ? 1 : 0

  name                = "${var.vnet_name}-nat"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"

  tags = var.tags
}

# NAT Gateway Public IP Association
resource "azurerm_nat_gateway_public_ip_association" "main" {
  count = var.enabled && var.enable_nat_gateway ? 1 : 0

  nat_gateway_id       = azurerm_nat_gateway.main[0].id
  public_ip_address_id = azurerm_public_ip.main[0].id
}

# NAT Gateway Subnet Association
resource "azurerm_subnet_nat_gateway_association" "main" {
  count = var.enabled && var.enable_nat_gateway ? 1 : 0

  subnet_id      = azurerm_subnet.main[0].id
  nat_gateway_id = azurerm_nat_gateway.main[0].id
}

# DDoS Protection Plan
resource "azurerm_network_ddos_protection_plan" "main" {
  count = var.enabled && var.enable_ddos_standard ? 1 : 0

  name                = "${var.vnet_name}-ddos"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Update VNet with DDoS protection
resource "azurerm_virtual_network" "with_ddos" {
  count = var.enabled && var.enable_ddos_standard ? 1 : 0

  name                = azurerm_virtual_network.main[0].name
  address_space       = azurerm_virtual_network.main[0].address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_servers         = var.custom_dns_servers

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.main[0].id
    enable = true
  }

  tags = var.tags

  depends_on = [azurerm_virtual_network.main]
}

# Azure Bastion
resource "azurerm_bastion_host" "main" {
  count = var.enabled && var.enable_bastion ? 1 : 0

  name                = "${var.vnet_name}-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion[0].id
    public_ip_address_id = azurerm_public_ip.bastion[0].id
  }

  tags = var.tags
}

# Public IP for Bastion
resource "azurerm_public_ip" "bastion" {
  count = var.enabled && var.enable_bastion ? 1 : 0

  name                = "${var.vnet_name}-bastion-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

# VNet Peering (optional)
resource "azurerm_virtual_network_peering" "main" {
  for_each = var.enabled && var.enable_peering ? var.peering_vnets : {}

  name                      = "peer-${each.key}"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.main[0].name
  remote_virtual_network_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${each.value.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${each.value.vnet_name}"

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  depends_on = [azurerm_virtual_network.main]
}

# Data source for current context
data "azurerm_client_config" "current" {}

# Outputs
output "vnet_id" {
  value       = try(azurerm_virtual_network.main[0].id, null)
  description = "Virtual Network ID"
}

output "vnet_name" {
  value       = try(azurerm_virtual_network.main[0].name, null)
  description = "Virtual Network name"
}

output "subnet_id_primary" {
  value       = try(azurerm_subnet.main[0].id, null)
  description = "Primary Subnet ID"
}

output "subnet_name_primary" {
  value       = try(azurerm_subnet.main[0].name, null)
  description = "Primary Subnet name"
}

output "nsg_id" {
  value       = try(azurerm_network_security_group.main[0].id, null)
  description = "Network Security Group ID"
}

output "nat_gateway_id" {
  value       = try(azurerm_nat_gateway.main[0].id, null)
  description = "NAT Gateway ID"
}

output "bastion_host_id" {
  value       = try(azurerm_bastion_host.main[0].id, null)
  description = "Bastion Host ID"
}

output "public_ip_address" {
  value       = try(azurerm_public_ip.main[0].ip_address, null)
  description = "Public IP address"
}
