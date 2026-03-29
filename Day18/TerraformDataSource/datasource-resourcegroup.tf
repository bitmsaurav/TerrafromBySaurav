data "azurerm_resource_group" "rgds" {
  depends_on = [azurerm_resource_group.myrg]
  name       = local.rg_name
}

# Tesing DataSource using outputs

#Resource group name from the datasource
output "ds_rg_name" {
  value = data.azurerm_resource_group.rgds.name
}
#Resource group location from the datasource
output "ds_rg_loctaion" {
  value = data.azurerm_resource_group.rgds.location
}
# Resource group ID from the datasource
output "ds_rg_id" {
  value = data.azurerm_resource_group.rgds.id

}