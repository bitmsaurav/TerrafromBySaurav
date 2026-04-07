# input variables
# 1. Bussiness unit
variable "bussiness_unit" {
  description = "This is the bussiness unit for which we are creating the infrastructure"
  type        = string
  default     = "Sales"

}
# 2. Environment        
variable "environment" {
  description = "This is the environment for which we are creating the infrastructure"
  type        = string
  default     = "Dev"

}
# 3. Resource_group_name
variable "resource_group_name" {
  description = "this is resource_group_name"
  type        = string
  default     = "mithunsales-rg"
}
# 4. Location
variable "location" {
  description = "This is the location for which we are creating the infrastructure"
  type        = string
  default     = "eastus"

}

# 5.Virtual network name
variable "virtual_network_name" {
  description = "This is the virtual network name for which we are creating the infrastructure"
  type        = string
  default     = "mithunsales-vnet"

}

#  6. virtual network address -dev

variable "virtual_network_address_dev" {
  description = "This is the virtual network address for dev environment for which we are creating the infrastructure"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

# 7. virtual network address -
variable "virtual_network_address_all" {
  description = "This is the virtual network address for prod environment for which we are creating the infrastructure"
  type        = list(string)
  default     = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
}
