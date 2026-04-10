# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  name                  = local.vm_name
  computer_name         = local.vm_name # Hostname of the VM
  resource_group_name   = azurerm_resource_group.myrg.name
  location              = azurerm_resource_group.myrg.location
  size                  = "Standard_dc1ds_v3"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.myvmnic.id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name                 = "osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
  tags        = local.common_tags
}