# local value block
locals {
  # Use case:short the name for more readebility
  rg_name   = "${var.business_unit}-${var.environment}-${var.resource_group_name}"
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  # use case 2: comman tags to be assigend to all resource
  service_name = "demo service"
  owner        = "mithun chakarwarti"
  comman_tags = {
    service = local.service_name
    owner   = local.owner
  }

}