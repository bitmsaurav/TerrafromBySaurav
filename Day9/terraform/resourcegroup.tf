resource "azurerm_resource_group" "myrg" {
  name     = "${var.bussiness_unit}-${var.environment_name}-${var.resourse_group_name}"
  location = var.resourse_group_location
}