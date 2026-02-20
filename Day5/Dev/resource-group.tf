# Resource 1= Azure Resource Group
resource "azurerm_resource_group" "myrg" {

  name     = "${var.business_unit}-${var.envitnoment}-${var.resource_group_name}"
  location = var.resource_location_name

}