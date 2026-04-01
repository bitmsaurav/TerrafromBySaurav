# local value Block
locals {
  #Use Case-1:shortent the name for more reablity
  vm_name = "${var.bussiness_unit}-${var.environment_name}-${var.virtual_machine_name}"
  # 2. use case:commen tags to be assigend in all resource
  service_name = "demo service"
  owner        = "saurav kunal"
  common_tags = {
    service = local.service_name
    owner   = local.owner
  }
}
