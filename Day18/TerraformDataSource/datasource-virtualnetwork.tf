data "azurerm_virtual_network" "vnetds" {
  depends_on          = [azurerm_virtual_network.myvnet]
  name                = local.vnet_name
  resource_group_name = local.rg_name

}

## Test Datasource using outputs

# virtual network name from datasource
output "ds_vnet_name" {
  value = data.azurerm_virtual_network.vnetds.name

}
# virtual network id from datasource
output "ds_vnet_id" {
  value = data.azurerm_virtual_network.vnetds.id

}
# virtual network address speacs from datasource
output "ds_vnet_address_specs" {
  value = data.azurerm_virtual_network.vnetds.address_space

}