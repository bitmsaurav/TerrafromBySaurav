variable "enabled" {
  description = "Enable or disable the VNet module"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "Target resource group for VNet"
  type        = string
}

variable "location" {
  description = "Azure region for the VNet"
  type        = string
}

variable "name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "CIDR address space for the VNet"
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to the VNet"
  type        = map(string)
}
