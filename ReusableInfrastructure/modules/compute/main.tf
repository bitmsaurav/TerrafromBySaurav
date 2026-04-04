###############################################################################
# Compute Module - Virtual Machines, Disks, Scale Sets
###############################################################################

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

variable "nic_name" {
  description = "Network Interface name prefix"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vm_name" {
  description = "Virtual Machine name prefix"
  type        = string
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 1
  validation {
    condition     = var.vm_count >= 1 && var.vm_count <= 100
    error_message = "VM count must be between 1 and 100."
  }
}

variable "vm_size" {
  description = "Virtual Machine size"
  type        = string
  default     = "Standard_B2s"
}

variable "vm_os_disk_type" {
  description = "OS disk type (Premium_LRS, Standard_LRS, StandardSSD_LRS)"
  type        = string
  default     = "StandardSSD_LRS"
}

variable "vm_image" {
  description = "VM image details"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

variable "enable_managed_disk" {
  description = "Enable managed disks"
  type        = bool
  default     = true
}

variable "additional_data_disks" {
  description = "Number of additional data disks to attach"
  type        = number
  default     = 0
}

variable "subnet_id" {
  description = "Subnet ID for network interface"
  type        = string
}

variable "nsg_id" {
  description = "Network Security Group ID"
  type        = string
}

variable "enable_public_ip" {
  description = "Enable public IP assignment to VMs"
  type        = bool
  default     = false
}

variable "enable_managed_identity" {
  description = "Enable managed identity for VMs"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

# Network Interfaces
resource "azurerm_network_interface" "main" {
  count = var.enabled ? var.vm_count : 0

  name                = "${var.nic_name}-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testConfiguration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# Associate NSG with Network Interfaces
resource "azurerm_network_interface_security_group_association" "main" {
  count = var.enabled ? var.vm_count : 0

  network_interface_id      = azurerm_network_interface.main[count.index].id
  network_security_group_id = var.nsg_id
}

# Public IPs (optional)
resource "azurerm_public_ip" "main" {
  count = var.enabled && var.enable_public_ip ? var.vm_count : 0

  name                = "${var.vm_name}-pip-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

# Associate Public IPs with Network Interfaces
resource "azurerm_network_interface_public_ip_association" "main" {
  count = var.enabled && var.enable_public_ip ? var.vm_count : 0

  network_interface_id = azurerm_network_interface.main[count.index].id
  public_ip_address_id = azurerm_public_ip.main[count.index].id
}

# Virtual Machines
resource "azurerm_linux_virtual_machine" "main" {
  count = var.enabled ? var.vm_count : 0

  name                = "${var.vm_name}-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size

  admin_username = "azureuser"

  # Disable password authentication and use SSH keys
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/../../ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.vm_os_disk_type
  }

  source_image_reference {
    publisher = var.vm_image.publisher
    offer     = var.vm_image.offer
    sku       = var.vm_image.sku
    version   = var.vm_image.version
  }

  network_interface_ids = [azurerm_network_interface.main[count.index].id]

  # Managed identity
  identity {
    type = var.enable_managed_identity ? "SystemAssigned" : "None"
  }

  tags = var.tags

  depends_on = [azurerm_network_interface.main]
}

# Additional Data Disks
resource "azurerm_managed_disk" "data_disk" {
  count = var.enabled ? (var.vm_count * var.additional_data_disks) : 0

  name                 = "${var.vm_name}-datadisk-${floor(count.index / var.additional_data_disks) + 1}-${(count.index % var.additional_data_disks) + 1}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.vm_os_disk_type
  create_option        = "Empty"
  disk_size_gb         = 128

  tags = var.tags
}

# Attach data disks to VMs
resource "azurerm_virtual_machine_data_disk_attachment" "data_disk" {
  count = var.enabled ? (var.vm_count * var.additional_data_disks) : 0

  managed_disk_id    = azurerm_managed_disk.data_disk[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.main[floor(count.index / var.additional_data_disks)].id
  lun                = count.index % var.additional_data_disks
  caching            = "ReadWrite"
}

# Outputs
output "vm_ids" {
  value       = try(azurerm_linux_virtual_machine.main[*].id, [])
  description = "Virtual Machine IDs"
}

output "vm_names" {
  value       = try(azurerm_linux_virtual_machine.main[*].name, [])
  description = "Virtual Machine names"
}

output "vm_private_ips" {
  value       = try(azurerm_network_interface.main[*].private_ip_address, [])
  description = "Virtual Machine private IP addresses"
}

output "vm_public_ips" {
  value       = try(azurerm_public_ip.main[*].ip_address, [])
  description = "Virtual Machine public IP addresses"
}

output "network_interface_ids" {
  value       = try(azurerm_network_interface.main[*].id, [])
  description = "Network Interface IDs"
}
