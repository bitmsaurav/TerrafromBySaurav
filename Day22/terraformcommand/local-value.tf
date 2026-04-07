locals {
  rg_name   = "${var.bussiness_unit}-${var.environment}-${var.resource_group_name}"
  vnet_name = "${var.bussiness_unit}-${var.environment}-${var.virtual_network_name}"
  #common tags
  service_name = "Demo service"
  owner        = "mithun"
  common_tags = {
    service = local.service_name
    owner   = local.owner
  }
  # with equals(==)

  vnet_address_space = (var.environment == "Dev" ? var.virtual_network_address_dev : var.virtual_network_address_all)

  # with not equals(!=)
  # vnet_address_space= (var.environment != "Dev" ? var.virtual_network_address_all : var.virtual_network_address_dev)

}