# 1.Busssiness unit name
variable "bussiness_unit" {
  description = "bussiness unit name"
  type        = string
  default     = "hr"
}

# 2.environment name
variable "environment_name" {
  description = "environment name"
  type        = string
  default     = "dev"
}
#3.Resource group name
variable "resource_group_name" {
  description = "this is the resource group name"
  type        = string
  default     = "yrg"
}
#4: Resource group location
variable "resource_group_location" {
  description = "this resource group location"
  type        = string
  default     = "eastus"

}
#5.virtual network name
variable "virtual_network_name" {
  description = "this is virtual network name"
  type        = string
  default     = "myvnet"

}
#6:subnet name
variable "subnet_name" {
  description = "this is subnet name"
  type        = string


}
#7.public ip
variable "publicip_name" {
  description = "this is public ip name"
  type        = string

}
#8: network infrace
variable "network_interface_name" {
  description = "this is the network interface name"
  type        = string

}
# 9. virtual machine name
variable "virtual_machine_name" {
  description = "this is the virtual machine name"
  type        = string

}