# Crate Virtual Network

resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.envitnoment}-${var.virtual_network_name}"
  address_space       = var.virtual_network_address_space
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = var.commn_tags
}

# create subnet
resource "azurerm_subnet" "mysubnet" {
  # name                 = "mysubnet-1"
  name                 = "${azurerm_virtual_network.myvnet.name}-${var.subnet_name}"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.3.0.0/24"]

}

# Creat public ip address

resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label   = "app1-vm-${random_string.myrandom.id}"
  #sku=var.public_ip_sku["eastus"]
  sku = lookup(var.public_ip_sku,var.resource_location_name,"Basic")
  tags = var.commn_tags
}

# Create network interface
resource "azurerm_network_interface" "myvmnic" {
  name                = "vmnic"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip.id
  }

}