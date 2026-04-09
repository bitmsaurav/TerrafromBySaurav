locals {
  rg_name   = "${var.bussiness_unit}-${terraform.workspace}-${var.resource_group_name}"
  vnet_name = "${var.bussiness_unit}-${terraform.workspace}-${var.virtual_network_name}"
  snet_name = "${var.bussiness_unit}-${terraform.workspace}-${var.subnet_name}"
  pip_name  = "${var.bussiness_unit}-${terraform.workspace}-${var.publicip_name}"
  nic_name  = "${var.bussiness_unit}-${terraform.workspace}-${var.network_interface_name}"
  vm_name   = "${var.bussiness_unit}-${terraform.workspace}-${var.virtual_machine_name}"

  service_name = "demo service"
  owner        = "saurav kunal"
  common_tags = {
    service = local.service_name
    owner   = local.owner
  }
}