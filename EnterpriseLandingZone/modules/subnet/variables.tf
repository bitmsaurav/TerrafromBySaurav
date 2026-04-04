variable "enabled" {
  description = "Enable or disable subnet creation"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "Resource group containing the subnets"
  type        = string
}

variable "location" {
  description = "Azure region for the subnets"
  type        = string
}

variable "virtual_network_name" {
  description = "Parent VNet name for this subnet set"
  type        = string
}

variable "subnets" {
  description = "Subnet definitions keyed by logical name"
  type = map(object({
    prefix = string
  }))
}

variable "nsg_id" {
  description = "Optional NSG ID to associate with each subnet"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to all created subnets"
  type        = map(string)
}
