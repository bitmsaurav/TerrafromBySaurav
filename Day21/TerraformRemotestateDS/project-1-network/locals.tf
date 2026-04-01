# local value Block
locals {
  #Use Case-1:shortent the name for more reablity
  rg_name   = "${var.bussiness_unit}-${var.environment_name}-${var.resource_group_name}"
  vnet_name = "${var.bussiness_unit}-${var.environment_name}-${var.virtual_network_name}"
  snet_name = "${var.bussiness_unit}-${var.environment_name}-${var.subnet_name}"
  pip_name  = "${var.bussiness_unit}-${var.environment_name}-${var.publicip_name}"
  nic_name  = "${var.bussiness_unit}-${var.environment_name}-${var.network_interface_name}"

  # 2. use case:commen tags to be assigend in all resource
  service_name = "demo service"
  owner        = "saurav kunal"
  common_tags = {
    service = local.service_name
    owner   = local.owner
  }
}
