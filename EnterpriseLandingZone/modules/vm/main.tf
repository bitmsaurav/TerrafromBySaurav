resource "azurerm_network_interface" "main" {
  count               = var.enabled ? var.vm_count : 0
  name                = format("%s-nic-%02d", var.name, count.index + 1)
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_public_ip" "main" {
  count               = var.enabled && var.enable_public_ip ? var.vm_count : 0
  name                = format("%s-pip-%02d", var.name, count.index + 1)
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_network_interface_public_ip_association" "main" {
  count = var.enabled && var.enable_public_ip ? var.vm_count : 0

  network_interface_id = azurerm_network_interface.main[count.index].id
  public_ip_address_id = azurerm_public_ip.main[count.index].id
}

resource "azurerm_linux_virtual_machine" "main" {
  count               = var.enabled ? var.vm_count : 0
  name                = format("%s-%02d", var.name, count.index + 1)
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [azurerm_network_interface.main[count.index].id]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
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

  identity {
    type = var.enable_managed_identity ? "SystemAssigned" : "None"
  }

  tags = var.tags
}

output "vm_ids" {
  description = "IDs of created VMs"
  value       = try(azurerm_linux_virtual_machine.main[*].id, [])
}

output "vm_names" {
  description = "Names of created VMs"
  value       = try(azurerm_linux_virtual_machine.main[*].name, [])
}

output "vm_private_ips" {
  description = "Private IP addresses of created VMs"
  value       = try(azurerm_network_interface.main[*].private_ip_address, [])
}

output "vm_public_ips" {
  description = "Public IP addresses of created VMs"
  value       = try(azurerm_public_ip.main[*].ip_address, [])
}
