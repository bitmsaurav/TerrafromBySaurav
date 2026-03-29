variable "business_unit" {
  description = "Bussines unit name"
  type        = string
  default     = "hr"

}
variable "environment" {
  description = "environment name"
  type        = string
  # default     = "dev"
  default = "qa"

}
variable "resource_group_name" {
  description = "value"
  type        = string
  default     = "mithun-rg"


}
variable "resoure_group_location" {
  description = "value"
  type        = string
  default     = "East Us"


}
variable "virtual_network_name" {
  description = "virtual_network_name"
  type        = string
  default     = "mithun-vnet"

}

variable "vnet_address_spec_dev" {
  description = "virtual network address speacs for dev env"
  type        = list(string)
  default     = ["10.0.0.0/16"]

}
variable "vnet_address_spec_all" {
  description = "Virtual network address spec for all Envirnment expect dev"
  type        = list(string)
  default     = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]

}

