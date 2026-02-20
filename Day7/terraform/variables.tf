#Input variables

# 1. Business Unit name
variable "business_unit" {
  description = "This is a Bussiness Unit Name"
  type        = string
  default     = "hr"
}

#2. Envirnoment Name

variable "envitnoment" {
  description = "This is the Environament Name"
  type        = string
  default     = "dev"

}

#3 . Resoure Group name

variable "resource_group_name" {
  description = "this is the resource group name"
  type        = string
  default     = "myrg"
}

#4. Resource location name
variable "resource_location_name" {
  description = "this is the resource location name"
  type        = string
  default     = "centralindia"

}

#5.variable for network name
variable "virtual_network_name" {
  description = "This the Network name"
  type        = string
  default     = "myvnet"

}

#6 subnet name:Assien when prompted using CLI

variable "subnet_name" {
  description = "this the subnet name"
  type        = string

}
# virtual network address speace
variable "virtual_network_address_space" {
  description = "this the virtual network address space"
  type        = list(string)
  default     = ["102.12.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]

}