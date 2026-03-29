data "azurerm_resource_group" "mithunrgds" {
  name = "dsdemo"
}

output "ds_rg_name1" {
  value = data.azurerm_resource_group.mithunrgds.name

}
output "ds_rg_location1" {
  value = data.azurerm_resource_group.mithunrgds.location

}
